function [P, y, u] = ident_you()
    hf = figure('MenuBar', 'none', 'OuterPosition', [100, 100, 800, 450], 'Resize', 'off', 'Name', 'Identify Yourself!!', 'NumberTitle', 'off', 'Color', [0.2, 0.2, 0.2]);
    
    input_type = DispTitle(hf);
    [y, u] = IdentMain(hf, input_type);
    P = DispResult(hf, y, u);
end