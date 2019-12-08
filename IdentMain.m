function [y, u] = IdentMain(hf, input_mode)
    u = MakeInputData(input_mode);
    y = zeros(size(u));
    t = 0.05 * (0:length(u)-1);
    ha = axes(hf, 'Color', [0.2, 0.2, 0.2], 'XLim', [0 t(end)], 'XTickLabel', {}, 'YTickLabel', {}, 'YLim', [-1.1, 1.1], 'Position', [0.05 0.1 0.9 0.8], 'LineWidth', 2, 'XColor', [1 1 1], 'YColor', [1 1 1], 'GridColor', [1 1 1], 'XGrid', 'on', 'YGrid', 'on');
    
    WaitForPlayer(ha);
    
    hold(ha, 'on');
    hsc = scatter(0, 0, 200, 'MarkerEdgeColor', 'none', 'MarkerFaceColor', [1 1 1]);
    i = 1;
    yt = 0;
    
    function OnMouseMove(~, ~)
        yt = ha.CurrentPoint(1,2);
    end
    
    function OnTimerElapsed(~,~)
        hsc.XData = t(i);
        hsc.YData = u(i);
        plot(ha, t(i), yt, 'o', 'Color', [0.8500    0.3250    0.0980]);
        
        y(i) = yt;
        i = i + 1;
    end
    
    hf.WindowButtonMotionFcn = @OnMouseMove;
    hold(ha, 'on');
    tmr = timer('Period', 0.05, 'TimerFcn', @OnTimerElapsed, 'BusyMode', 'queue', 'ExecutionMode', 'fixedRate', 'TasksToExecute', length(u));
    start(tmr);
    wait(tmr);
    
    hf.WindowButtonMotionFcn = [];
    cla(ha);
end

function WaitForPlayer(ha)
    ha.NextPlot = 'add';
    
    t_wait = 5;
    
    htx_rdy = text(ha, 10, 0.2, 'Track œ!', 'FontSize', 36, 'FontName', 'Times New Roman', 'Color', [1 1 1], 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
    htx_tmr = text(ha, 10, -0.2, num2str(t_wait, '%1.1f'), 'FontSize', 36, 'FontName', 'Times New Roman', 'Color', [1 1 1], 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
    hsc = scatter(ha, 0, 0, 200, 'filled', 'MarkerEdgeColor', 'none', 'MarkerFaceColor', [1 1 1]);
    
    hsc.ButtonDownFcn = @OnClicked;
    theta = 0;
    ts = 0.05;
    while(t_wait > 0)
        alpha(ha, abs(cos(theta)));
        htx_tmr.String = num2str(t_wait, '%1.1f');
        
        theta = theta + pi/20;
        t_wait = t_wait - ts;
        pause(ts);
    end
    
    delete(htx_rdy);
    delete(htx_tmr);
    delete(hsc);
end

function u = MakeInputData(input_mode)
    len = 400;
    period = 10;
    u = zeros(len, 1);
    reg = round(rand(1, 35));
    
    change_count = period;
    for t = 2:len
        change_count = change_count - 1;
        if (change_count == 0)
            if ( input_mode == "mser" )
                u(t) = round(reg(end-1)-0.5);
            elseif ( reg(end-1) ~= reg(end) )
                u(t) = 2 * round(reg(end-1)-0.5) * (rand()-0.5);
            else
                u(t) = u(t-1);
            end
            
            ro = xor(reg(2), reg(35));
            reg(2:end) = reg(1:end-1);
            reg(1) = ro;
            
            change_count = period;
        else
            u(t) = u(t-1);
        end
    end
end