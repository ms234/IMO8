%load_treatment
global tend

treatment1 = treatment(t0,tend);
switch treatment_plan 
    case 1
        %plan 1 -- drug1, intermittent
        for n = 1:2:floor(tend/14)-1
            n
            treatment1 = treatment1.add(1,14*n,14*(n+1));
        end
        color = 'r';
    case 2
        %plan 2 -- drug2, intermittent
        for n = 1:2:floor(tend/14)-1
            n
            treatment1 = treatment1.add(2,14*n,14*(n+1));
        end
        color = 'g';
    case 3
        %plan 3 -- drug3, intermittent
        for n = 1:2:floor(tend/14)-1
            n
            treatment1 = treatment1.add(3,14*n,14*(n+1));
        end
        color = 'b';
    case 4
        %plan 4 -- drug1, continuous
        for n = 1:1:floor(tend/14)-1
            n
            treatment1 = treatment1.add(1,14*n,14*(n+1));
        end
        color = 'r';
    case 5
        %plan 5 -- drug2, continuous
        for n = 1:1:floor(tend/14)-1
            n
            treatment1 = treatment1.add(2,14*n,14*(n+1));
        end
        color = 'g';
    case 6
        %plan 6 -- drug3, continuous
        for n = 1:1:floor(tend/14)-1
            n
            treatment1 = treatment1.add(3,14*n,14*(n+1));
        end
        color = 'b';
    case 7
        %plan 7 -- two drugs, intermittently
        flag = 0;
        drug1 = 1;
        drug2 = 2;
        for n = 1:2:floor(tend/14)-1
            n
            if(flag == 0)
                treatment1 = treatment1.add(drug1,14*n,14*(n+1));
                flag = mod(flag+1,2);
            else
                treatment1 = treatment1.add(drug2,14*n,14*(n+1));
                flag = mod(flag+1,2);
            end
        end
        color = 'r';
end
