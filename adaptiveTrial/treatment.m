classdef treatment
    properties
        t0;
        tend;
        N;
        plan;
    end
    methods
        function obj = treatment(t0,tend)
            obj.t0 = 0;
            obj.tend = tend;
            obj.N = 0;
            obj.plan = [];
        end
        function obj = add(obj, type, start, final)
            obj.plan = [obj.plan; type, start, final];
            obj.N = obj.N+1;
        end
        function t_segments = make(obj)
            vt = sort(unique([obj.t0,obj.plan(:,2)',obj.plan(:,3)',obj.tend]));
            N_seg = length(vt);
            t_segments.N = N_seg-1;
            for n = 1:N_seg-1
                t_segments.tspan{n} = [vt(n),vt(n+1)];
                t_segments.ton{n} = [0,0,0];
            end
            for m = 1:obj.N
                plan_n = obj.plan(m,:);
                type = plan_n(1);
                t1 = plan_n(2);
                t2 = plan_n(3);
                for n = 1:N_seg-1
                    tspan = t_segments.tspan{n};
                    if(tspan(1) >= t1 && tspan(2) <= t2)
                        t_segments.ton{n}(type) = tspan(1);
                    end
                end
            end
            t_segments
        end
    end
end