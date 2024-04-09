;*******************************************
;******** Reviser: Xv Tianyi   *************
;******** Revision time: 2024.03.20 ********
;******** Structure: MOM_demo    ***********
;*******************************************

pcDefinePCell(list(ddGetObj("xutianyi") "MOM12_W0360_S0135_L30_F50" "layout")  
    (
        
    )
    let(
    ()

    ;******************************Define parameter************************************
    ;*************Define variable*******************
    l=30;                                       total length
    ;w=15;                                       total width
    w1=0.36;                                   finger width
    s=0.135;                                    finger space
    wa=0.045;                                   via width
    w2=0.495;                                    sum of finger width and finger space
    l1=0.225;                                   gap between metal line and electrode
    n1=25;          	                        finger number
    le=0.15;                                    electrode width
    EN=0.03;                                    distance between via and metal edge
    EN1=0.053;                                  distance between via and metal side edge
    sa=0.072;                                    distance between two via
    n2=201;   number of via
    sh0=0.15
    sh1=75
    en=0.075

    ;*************Define layer**********************
    (pcLayer1 = "M1")
    (pcLayer2 = "M2")
    (pcLayer3 = "V1")
    (pcLayerDMYBLK = "DMYBLK")
    (pcPurpose = "drawing")
    (pcPurposeDMYBLK = "marking")

    ;******************************Main function***************************************

    ;*************Metal line Drawing****************
    ;*************Drawing M1************************
    for(i 0 n1-1
        list1=list((2*i*w2):le (w1+2*i*w2):l+le-l1);   Define Rectangle coordinates
        list2=list(w2+i*2*w2:l1+le w2+w1+i*2*w2:l+le)
        (pcInst = dbCreateRect(pcCellView 
            list(pcLayer1 pcPurpose) 
            list1))
        (pcInst = dbCreateRect(pcCellView 
            list(pcLayer1 pcPurpose) 
            list2))
    );for i loop


    ;*************Drawing M2************************
    for(i 0 n1-1
        list1=list(2*i*w2:l1+le 2*i*w2+w1:l+le)
        list2=list(w2+2*i*w2:le w2+2*i*w2+w1:l+le-l1)
        (pcInst = dbCreateRect(pcCellView 
            list(pcLayer2 pcPurpose) 
            list1))
        (pcInst = dbCreateRect(pcCellView 
            list(pcLayer2 pcPurpose) 
            list2))
    );for i loop

    ;*************Top and bottom electrode**********
    list3=list(0:0 (w1+2*(n1-1)*w2):le)
    (pcInst = dbCreateRect(pcCellView 
        list(pcLayer1 pcPurpose) 
        list3))  
     
    list4=list(w2:0 (n1-1)*2*w2+w1+w2:le)
    (pcInst = dbCreateRect(pcCellView 
        list(pcLayer2 pcPurpose) 
        list4))

    list5=list(w2:l+le 2*(n1-1)*w2+w1+w2:l+le+le)
    (pcInst = dbCreateRect(pcCellView 
        list(pcLayer1 pcPurpose) 
        list5))
    list6=list(0:l+le (w1+2*(n1-1)*w2):l+le+le)
    (pcInst = dbCreateRect(pcCellView 
        list(pcLayer2 pcPurpose) 
        list6))
    
    ;*************Via Drawing*********************** 
    for(i 0 n2-1
       list7=list(w2+en+i*(sa+wa):0-EN1-wa+le w2+en+i*(sa+wa)+wa:0-EN1+le)
       list8=list(w2+en+i*(sa+wa):l+EN1+le w2+en+i*(sa+wa)+wa:l+EN1+wa+le)
       (pcInst = dbCreateRect(pcCellView 
              list(pcLayer3 pcPurpose) 
              list7))
       (pcInst = dbCreateRect(pcCellView 
              list(pcLayer3 pcPurpose) 
              list8))
    );for i loop

    list9=list(0:0 49*(w1+s)+w1:l+le+le)
    (pcInst = dbCreateRect(pcCellView 
        list(pcLayerDMYBLK pcPurposeDMYBLK) 
        list9))

    );let
);pc