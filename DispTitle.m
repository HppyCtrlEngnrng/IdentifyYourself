function input_type = DispTitle(hf)
    ha = axes(hf, 'XColor', 'none', 'YColor', 'none', 'Color', [0.2, 0.2, 0.2], 'XTick', [], 'YTick', [], 'Box', 'off', 'XLim', [0 800], 'YLim', [0 450], 'Position', [0, 0, 1, 1]);

    hold(ha, 'on');
    pbaspect(ha);

    pos_center = [400, 225];
    width_you = 50;
    
    rectangle(ha, 'Position', [pos_center(1) - width_you/2, pos_center(2), width_you, width_you], 'Curvature', 1, 'EdgeColor', 'none', 'FaceColor', [1, 1, 1]);
    rectangle(ha, 'Position', [pos_center(1) - width_you/2, pos_center(2) + width_you/1.5, width_you, width_you], 'Curvature', 1, 'EdgeColor', 'none', 'FaceColor', [1, 1, 1]);
    rectangle(ha, 'Position', [pos_center(1) - width_you/2, pos_center(2) - width_you/2, width_you, width_you], 'EdgeColor', 'none', 'FaceColor', [1, 1, 1]);
    text(ha, pos_center(1), pos_center(2)+1.2*width_you, '?', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 24, 'FontName', 'Times New Roman');
    
    button_lb = 70;
    button_offlr = 300;
    hrect_mser = rectangle(ha, 'Position', [pos_center(1)-button_offlr, button_lb, 200, 100], 'LineWidth', 2, 'Curvature', 0.25, 'EdgeColor', [1 1 1], 'FaceColor', [0.2 0.2 0.2], 'PickableParts', 'all');
    hrect_rstep = rectangle(ha, 'Position', [pos_center(1)+button_offlr-200, button_lb, 200, 100], 'LineWidth', 2, 'Curvature', 0.25, 'EdgeColor', [1 1 1], 'FaceColor', [0.2 0.2 0.2], 'PickableParts', 'all');
    text(ha, pos_center(1)-button_offlr+100, button_lb+50, 'M-Series', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 24, 'FontName', 'Times New Roman', 'Color', [1 1 1], 'PickableParts', 'none');
    text(ha, pos_center(1)+button_offlr-100, button_lb+50, 'Random Step', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 24, 'FontName', 'Times New Roman', 'Color', [1 1 1], 'PickableParts', 'none');
    
    quiver(ha, 40, 225, 360, 0, 'LineWidth', 1, 'Color', [1 1 1]);
    quiver(ha, 440, 225, 360, 0, 'LineWidth', 1, 'Color', [1 1 1]);
    
    s1 = 'Identify';
    x1 = 280*((0:length(s1)-1)/(length(s1)-1)) + 50;
    
    ht1 = zeros(1, length(s1));
    for c = 1:length(s1)
        ht1(c) = text(x1(c), 225, s1(c), 'Color', [1 1 1], 'FontSize', 20, 'FontName', 'Times New Roman', 'PickableParts', 'none');
    end
    
    s2 = 'Yourself!';
    x2 = 280*((0:length(s2)-1)/(length(s2)-1)) + 450;
    ht2 = zeros(1, length(s2));
    for c = 1:length(s2)
        ht2(c) = text(x2(c), 225, s2(c), 'Color', [1 1 1], 'FontSize', 20, 'FontName', 'Times New Roman', 'PickableParts', 'none');
    end
    
    ubuf = 225 * ones(length(s1), 1);
    ybuf = 225 * ones(length(s2), 1);
    u = 225;
    
    function OnMouseMove(~, ~)
        u = ha.CurrentPoint(1,2);
    end

    function OnMserClicked(~, ~)
        input_type = "mser";
    end

    function OnRstepClicked(~, ~)
        input_type = "rstep";
    end
    
    hf.WindowButtonMotionFcn = @OnMouseMove;
    hrect_mser.ButtonDownFcn = @OnMserClicked;
    hrect_rstep.ButtonDownFcn = @OnRstepClicked;
    
    input_type = "";
    
    while (isgraphics(hf) && input_type == "")
        ubuf(2:end) = ubuf(1:end-1);
        ybuf(2:end) = ybuf(1:end-1);
        ubuf(1) = u(1);
        ybuf(1) = 1.895*ybuf(1) - 0.9048*ybuf(3) + 0.0098*ubuf(end);
        
        for c = 1:length(s1)
            set(ht1(c), 'Position', [x1(c), ubuf(c), 0]);
        end
        
        for c = 1:length(s2)
            set(ht2(c), 'Position', [x2(c), ybuf(c), 0]);
        end
        
        pause(0.05);
    end
    
    hf.WindowButtonMotionFcn = [];
    cla(ha);
end

