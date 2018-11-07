function plotDrugApplicationWindow(t_segments)
v = ylim;
for n = 1:t_segments.N
    % assume one type of drug at a time
    tspan = t_segments.tspan{n}
    ton = t_segments.ton{n}
    alpha = 0.2;
    color = [1,1,1,alpha];
    if(ton(1) > 0)
        color = [1,0,0,alpha];
    end
    if(ton(2) > 0)
        color = [0,1,0,alpha];
    end
    if(ton(3) > 0)
        color = [0,0,1,alpha];
    end
    rectangle('Position',[tspan(1)+0.001,0.001,tspan(2)-0.001-tspan(1),1.1*v(2)-0.001],'Facecolor',color);
end
end
