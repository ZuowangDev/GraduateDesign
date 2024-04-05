from customtkinter import CTk, CTkFrame, CTkOptionMenu, CTkButton, CTkLabel, CTkEntry, CTkFont
from tkinter import messagebox
import json
import operator as op
import os
import re
import time


# 功能：导入模版文件
def load_file():

    # 当前目录pwd
    current_dir = os.getcwd()

    # 获得绝对路径
    templates_dir = os.path.join(current_dir, 'templates')
    template_dict = {}

    for filename in os.listdir(templates_dir):  
        if filename.endswith('.txt'):  

            # 构建文件的完整路径  
            file_path = os.path.join(templates_dir, filename)  
              
            # 读取文件内容  
            with open(file_path, 'r') as file:  
                content = file.read()

            # 按照文件中空两行划分，上半部分为json，下半部分为文本
            json_part, template_part = content.split('\n\n\n', 1)

            # json读取
            json_data = json.loads(json_part)
            parameter = json_data['parameter']
            expression = json_data['expression']

            # 文本清除前后空白后写入程序
            template_str = template_part.strip()

            # 读取后存入第一级字典，内容为原始的值
            template_dict[filename.rstrip('.txt')] = {  
                'parameter': parameter,  
                'expression': expression,  
                'template_str': template_str  
            }

    return template_dict

# 功能：将模型文件中的表达式中需要用户输入的变量换成值
def replace_variables(expression, variables):  

    # 使用正则表达式找到所有的变量（变量名由字母、数字和下划线组成）  
    pattern = r'\b([a-zA-Z_][a-zA-Z0-9_]*)\b'  

    # 使用字典中的值替换表达式中的变量  
    def replace_var(match):  
        var_name = match.group(1) 

        # 如果变量不存在，则返回变量名本身   
        return str(variables.get(var_name, var_name)) 
    
    # 使用re.sub和回调函数替换变量   
    return re.sub(pattern, replace_var, expression) 

# 功能：判断是否是运算符
def is_operator(token):  
    return token in ['+', '-', '*', '/', '%']  

# 功能：定义运算符优先级
def get_precedence(op):  
    precedences = {'+': 1, '-': 1, '*': 2, '/': 2, '%': 2}  
    return precedences[op]  

# 功能：支持浮点数，判断是否是数字
def is_number(s):  
    try: 

        # 尝试将字符串转换为浮点数  
        float(s)
        return True  
    except ValueError:  
        return False

# 功能：将中缀表达式转换成逆波兰表达式
def infix_to_postfix(expression):

    # 定义了两个栈
    # output：输出，stack：临时  
    output = []  
    stack = []  
    tokens = expression.replace('(', ' ( ').replace(')', ' ) ').split()  
  
    for token in tokens:  
        if is_number(token): 

            # 操作数直接压入output
            output.append(token)  
        elif is_operator(token):  
            while stack and is_operator(stack[-1]) and get_precedence(stack[-1]) >= get_precedence(token): 

                # 判断stack中优先级和待处理运算符优先级的关系
                # 弹出最后一个运算符，直到stack中的优先级都小于待处理运算符 
                output.append(stack.pop())  
            stack.append(token)  
        elif token == '(': 

            # 遇到左括号直接压入
            stack.append(token)  
        elif token == ')': 

            # 右括号一直弹出，直到遇到左括号，相当于堆栈中的堆栈
            top_token = stack.pop()  
            while top_token != '(':  
                output.append(top_token)  
                top_token = stack.pop()  
        else:  
            raise ValueError(f"Invalid token {token}")  
  
    while stack:  
        if stack[-1] == '(':  
            raise ValueError("Mismatched parentheses in expression")  
        output.append(stack.pop())

    # 返回的结果是转换出的逆波兰表达式   
    return ' '.join(output)  

# 功能：计算逆波兰表达式的值
def evaluate_postfix(postfix_expression):  
    stack = []  
    tokens = postfix_expression.split()  
  
    for token in tokens:  
        if is_number(token):  
            stack.append(float(token))  
        elif token in ['+', '-', '*', '/', '%']:  
            if len(stack) < 2:
                raise ValueError("Invalid postfix expression")  
            b = stack.pop()  
            a = stack.pop()  
            if token == '+':  
                result = a + b  
            elif token == '-':  
                result = a - b  
            elif token == '*':  
                result = a * b  
            elif token == '/':  
                if b == 0:  
                    raise ValueError("Division by zero")  
                result = a / b  
            elif token == '%': 
                # 向下取整   
                result = a // b
            stack.append(result)  
        else:  
            raise ValueError(f"Invalid token {token} in postfix expression")  
  
    if len(stack) != 1:  
        raise ValueError("Invalid postfix expression")  
    
    # 堆栈中最后一个值就是结果
    return stack[0]


# 加载框架的类，父类：CTkFrame
class loadframe(CTkFrame):

    # 功能：框架初始化；形参：选择的框架名(frame_name)，框架内容(frame)
    def __init__(self,master:CTkFrame,frame_name,frame: dict):
        super().__init__(master = master, corner_radius = 0, fg_color="transparent")
        self.rowconfigure((0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10), weight=1)
        self.columnconfigure(0, weight=1)
        self.columnconfigure(1, weight=4)
        self.frame_name = frame_name
        self.parameter = frame['parameter']
        self.expression = frame['expression']
        self.content = frame['template_str']

        # 存储所有参数值的字典，包括需要输入的值和表达式计算出的值
        self.parameter_value = {}
        self.entry = {}

        # 遍历标签文本列表，创建标签和输入框  
        for i, text in enumerate(self.parameter):  

            # 创建标签  
            label = CTkLabel(self, text=f"{text}  ", anchor="e", width=100)

            # 将标签放置到网格中  
            label.grid(row=i, column=0)  
      
            # 创建输入框  
            self.entry[text] = CTkEntry(self, width=160)  

            # 将输入框放置到网格中  
            self.entry[text].grid(row=i, column=1)  

    # 功能：输出文件，作为按钮的命令
    def output_file(self):
        for item in self.parameter:
            self.parameter_value[item] = float(self.entry[item].get())
        for key in self.expression:

            # 含变量中缀表达式 > 只含数字的中缀表达式 > 逆波兰表达式 > 计算结果
            self.parameter_value[key] = round(evaluate_postfix(infix_to_postfix(replace_variables(self.expression[key],self.parameter_value))), 4)
 
        self.content_processed = self.content.format(**self.parameter_value)

        try:
            with open(f"./output/{self.frame_name}_{time.strftime('%Y-%m-%d-%H-%M-%S')}.il", mode="w", encoding="utf-8") as fp:
                fp.write(self.content_processed)
            
            # 写入成功后，提示成功
            messagebox.showinfo(title="提示弹窗", message="文件生成成功")

        # 如果写入失败，则弹窗提示异常信息
        except Exception as exp:
            messagebox.showerror(title="提示弹窗", message=f"保存文件异常: {exp}")  
            return



class App(CTk):

    # 功能：GUI的初始化；形参：所有模版的内容字典
    def __init__(self, filed: dict):
        super().__init__()
        self._calc_window_pos()  # 生成窗口
        self.title("互联寄生测试结构模型自动生成")
        self.rowconfigure(0, weight=1)

        self.template_dict = filed

        # 框架字典：键为框架名，值为创建的框架
        self.frame_dict = {}

        self.frame_left = CTkFrame(self, fg_color="transparent")
        self.frame_left.grid(row=0, column=0, sticky="nsew", padx=50)
        self.frame_left.rowconfigure(0, weight=1)
        self.frame_left.rowconfigure(1, weight=1)
        self.frame_left.rowconfigure(2, weight=1)
        self.frame_left.rowconfigure(3, weight=1)
        self.frame_left.columnconfigure(0, weight=1)


        self.option_menu = CTkOptionMenu(self.frame_left, width=150, height=30, values=list(self.template_dict.keys()),command=self.frame_select)
        self.option_menu.grid(row=0, column=0, pady=70)
        btn_font_obj = CTkFont(size=20, weight="bold", family="微软雅黑")
        self.btn_gen = CTkButton(self.frame_left, text="确认", font=btn_font_obj)
        self.btn_gen.grid(row=1, column=0, pady=70)

        # 各个模型GUI的部分定义
        self.frame_right = CTkFrame(self, fg_color="transparent")
        self.frame_right.grid(row=0, column=1, sticky="nsew")
        self.frame_right.rowconfigure(0, weight=1)
        self.frame_right.columnconfigure(0, weight=1)
        
        for key in self.template_dict:
            self.frame_dict[key] = loadframe(self.frame_right,key,self.template_dict[key])
            print(type(self.frame_dict[key]))
        self.frame_select()

        self.init_dir()

    # 功能：检查是否创建output文件夹，如果没有则创建一个output文件夹
    def init_dir(self):

        output_dir_path = os.path.join(os.getcwd(), "output")

        if not os.path.exists(output_dir_path):
            try:
                os.mkdir(output_dir_path)
            except Exception as exp:
                messagebox.showerror(title="", message=f"创建文件夹失败: {exp}")
                return

    # 功能：设置窗体大小和位置
    def _calc_window_pos(self):

        root_width = 600
        root_height = 600
        screen_width = self.winfo_screenwidth()
        screen_height = self.winfo_screenheight()
        root_pos_x = int((screen_width - root_width) / 2)
        root_pos_y = int((screen_height - root_height) / 2)
        self.geometry(f'{root_width}x{root_height}+{root_pos_x}+{root_pos_y}')
        self.resizable(False, False)

    # 功能：改变GUI框架
    def frame_change(self,frame_name: str):

        # 切换下拉选项，同时切换下拉选项对应的输入参数
        frame_conf= dict(row = 0, column = 0, sticky = "nsew")
        for key in self.frame_dict:
            self.frame_dict[key].grid_forget()
        self.frame_dict[frame_name].grid(**frame_conf)
        self.btn_gen.configure(command = self.frame_dict[frame_name].output_file)

    # 功能：选择GUI框架
    def frame_select(self,*args):
        self.frame_change(self.option_menu.get())


# 程序入口
if __name__ == '__main__':
    filed = load_file()
    app = App(filed)
    app.mainloop()

    