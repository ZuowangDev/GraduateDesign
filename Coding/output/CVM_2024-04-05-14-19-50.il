;*******************************************
;******** Reviser: Xv Tianyi   *************
;******** Revision time: 2024.03.20 ********
;******** Structure: CVM1_demo    **********
;*******************************************

pcDefinePCell(list(ddGetObj("xvtianyi") "CVM12_W0045.0_S0045.0_L60.0_F555.0" "layout")
    (
    
    )
    let(
    ()

    ;******************************Define parameter************************************
    ;*************Define variable*******************
    n=555.0;                                     finger num 
    l1=60.0;                                      total length
    w1=0.045;                                   finger width
    s=0.045;                                    finger space
    w2=0.09;                                    sum of finger width and finger space
    l2=0.15;                                   electrode width
    wh=49.905
    lh=60.3
    start=5.1975                    

    ;*************Define layer**********************
    (pcLayer1 = "M1")
    (pcLayer2 = "M2")
    (pcPurpose = "drawing")
    (pcLayerDMYBLK = "DMYBLK")
    (pcPurposeDMYBLK = "marking")

    ;******************************Main function***************************************

    ;*************Metal line Drawing****************
    ;*************Drawing M1************************
    for(i 0 n-1
       list1=list((i*w2+start):l2 ((w1+i*w2)+start):l1+l2);   Define Rectangle coordinates

       (pcInst = dbCreateRect(pcCellView 
              list(pcLayer1 pcPurpose) 
              list1))
      
    );for i loop

    ;*************Drawing M2************************
     for(i 0 n-1
       list2=list(0+l2:(i*w2+start) l1+l2:((w1+i*w2)+start))
       (pcInst = dbCreateRect(pcCellView 
            list(pcLayer2 pcPurpose) 
            list2))
      
    );for i loop


    ;*************Top and bottom electrode**********
    list3=list(0+start:0 ((w1+(n-1)*w2)+start):l2)
    (pcInst = dbCreateRect(pcCellView 
        list(pcLayer1 pcPurpose) 
        list3)) 
    list4=list(0:start 0+l2:((w1+(n-1)*w2)+start))
    (pcInst = dbCreateRect(pcCellView 
        list(pcLayer2 pcPurpose) 
        list4))  
     
    list5=list(0+start:l1+l2 ((w1+(n-1)*w2)+start):(l1+l2+l2))
    (pcInst = dbCreateRect(pcCellView 
        list(pcLayer1 pcPurpose) 
        list5))
    list5=list(l1+l2:start (l1+l2+l2):((w1+(n-1)*w2)+start))
    (pcInst = dbCreateRect(pcCellView 
        list(pcLayer2 pcPurpose) 
        list5))


    ;*************Dummy Bloack Layer Drawing***********
    list6=list(0:0 lh:lh)
    (pcInst = dbCreateRect(pcCellView 
        list(pcLayerDMYBLK pcPurposeDMYBLK) 
        list6))
     
    );let  
);pc