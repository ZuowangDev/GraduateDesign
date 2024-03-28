;*******************************************
;******** Reviser: Xv Tianyi   *************
;******** Revision time: 2024.03.20 ********
;******** Structure: Kelvin_demo   *********
;*******************************************

pcDefinePCell(list(ddGetObj("xvtianyi") "Kelvin_M3_W0045.0_S0045.0_L30.0_F50.0_L" "layout")  
    (
    
        )
    let(
    ()
    ;*******************define parameter************************
    l=30.0;             total length
    ;w=45;             total width
    w1=0.045;           width
    s=0.045;            space
    w2=0.09;            sum of width and space
    we=0.08;            width of electrode
    (pcLayer1 = "M3")
    (pcPurpose = "drawing")
    n1=50.0
    n1_1=25.0

    ;*******************drawing M1************************
    for(i 0 n1-1
        list1=list(i*w2:0 (w1+i*w2):l)
        (pcInst = dbCreateRect(pcCellView 
            list(pcLayer1 pcPurpose) 
            list1))
        );for i

    ;*******************drawing electrode************************
    n2=fix(n1/2)
    if((n2*2)<n1
    then
        n3=n2
    else 
        n3=n2-1
    );if
    for(i 0 n2-1
        list1=list(2*i*(w1+s)+w1:0 2*i*(w1+s)+w1+s:we)
        (pcInst = dbCreateRect(pcCellView 
            list(pcLayer1 pcPurpose) 
            list1))
    );for

    for(i 0 n3-1
        list1=list(2*i*(w1+s)+w1+s+w1:l-we 2*i*(w1+s)+w1+s+w1+s:l)
        (pcInst = dbCreateRect(pcCellView 
            list(pcLayer1 pcPurpose) 
            list1))
    );for
    );let
);pc