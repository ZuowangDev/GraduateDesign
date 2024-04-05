;*******************************************
;******** Reviser: Xv Tianyi   *************
;******** Revision time: 2024.03.20 ********
;******** Structure: CCM1_demo    **********
;*******************************************

pcDefinePCell(list(ddGetObj("xvtianyi") "CCM1_W0045.0_S0045.0_L30.0_F50_L" "layout")
    (

    )
    let(
    ()

    ;******************************Define parameter************************************
    ;*************Define variable*******************
    width=0.045;                                finger width
    space=0.045;                                finger space
    w_electrode=0.15;                           electrode width
    l_gap=0.225;                                gap between metal line and electrode
    length=30.0;                                  totle length
    ly=29.775;                            finger length
    ;wtot=24;                                   total Width
    ;n1=fix(wtot/(width*2+space*2))-1;          one side finger number
    n1=24.0

    ;*************Define layer**********************
    (pcLayer1= "M1")
    (pcPurpose1 = "drawing" )
    (pcLayer2 = "DMYBLK")
    (pcPurpose2 = "marking")

    ;******************************Main function***************************************

    ;*************Metal line Drawing****************
    for(i 0 n1
        x1=i*2
        x2=i*2+1
        list1=list(x1*(width+space):w_electrode x1*(width+space)+width:(ly+w_electrode));   Define Rectangle coordinates
        (pcInst = dbCreateRect(pcCellView
            list(pcLayer1 pcPurpose1)
            list1))

        list2=list(x2*(width+space):(w_electrode+l_gap) x2*(width+space)+width:(ly+w_electrode+l_gap))
        (pcInst = dbCreateRect(pcCellView
            list(pcLayer1 pcPurpose1)
            list2))
    );for i loop

    ;*************Top and bottom electrode***********
    x3=n1*2+1
    x4=n1*2
    list3=list(0:0 (width*x3+space*x4):w_electrode)
    (pcInst = dbCreateRect(pcCellView
        list(pcLayer1 pcPurpose1)
        list3))
    list4=list((width+space:ly+w_electrode+l_gap) (width+space)*x3+width:(ly+w_electrode*2+l_gap))
    (pcInst = dbCreateRect(pcCellView
        list(pcLayer1 pcPurpose1)
        list4))

    ;*************Dummy Bloack Layer Drawing***********
    list5=list(0:0 x3*(width+space)+width:ly+w_electrode*2+l_gap)
    (pcInst = dbCreateRect(pcCellView
        list(pcLayer2 pcPurpose2)
        list5))
    );let
);pc