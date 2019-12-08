function P = DispResult(hf, y, u)
    tbs = ver;
  
    t = (0:length(y)-1)*0.05;
    if ( ~contains([tbs.Name], 'System Identification Toolbox') )
        b = y(4:end);
        A = [ y(3:end-1) y(2:end-2) y(1:end-3) u(3:end-1) u(2:end-2) u(1:end-3) ];
        
        theta = A\b;
        P = tf(theta(4:6)', [1; -theta(1:3)]', 0.05);
    else
        idd = iddata(y, u, 0.05);
        P = tf(arx(idd, [3, 3, 0], 'InputDelay', delayest(idd)));
    end
    
    y_sim = lsim(P, u, t);
    sakusha = load('P_hce.mat');
    P_hce = sakusha.P_hce;
    
    [mag, phase, w] = bode(P);
    mag = 20*log10(squeeze(mag));
    phase = squeeze(phase);
    
    [mag_hce, phase_hce] = bode(P_hce, w);
    mag_hce = 20*log10(squeeze(mag_hce));
    phase_hce = squeeze(phase_hce);
    
    hsa_mag = subplot(2,1,1);
    semilogx(w, mag_hce, 'w--', 'LineWidth', 2);
    hold on;
    semilogx(w, mag, 'w', 'LineWidth', 2);
    title(hsa_mag, 'Frequency Response', 'FontSize', 24, 'Color', [1 1 1], 'FontName', 'Times New Roman');
    ylabel('amplitude [dB]', 'FontSize', 18);
    set(hsa_mag, 'Color', [0.2, 0.2, 0.2], 'LineWidth', 2, 'XColor', [1 1 1], 'YColor', [1 1 1], 'GridColor', [1 1 1], 'XGrid', 'on', 'YGrid', 'on', 'FontSize', 10);
    legend(hsa_mag, '@HppyCtrlEngnrng', 'You', 'Location', 'southwest', 'TextColor', [1 1 1], 'Box', 'off', 'FontSize', 10);
    
    hsa_phase = subplot(2,1,2);
    semilogx(w, phase_hce, 'w--', 'LineWidth', 2);
    hold on;
    semilogx(w, phase, 'w', 'LineWidth', 2);
    ylabel('phase [deg]', 'FontSize', 18);
    xlabel('frequency [rad/s]', 'FontSize', 18);
    set(hsa_phase, 'Color', [0.2, 0.2, 0.2], 'LineWidth', 2, 'XColor', [1 1 1], 'YColor', [1 1 1], 'GridColor', [1 1 1], 'XGrid', 'on', 'YGrid', 'on', 'FontSize', 10);
    
    hf_comp = figure('MenuBar', 'none', 'Resize', 'off', 'Name', 'Identify Yourself!!', 'NumberTitle', 'off', 'Color', [0.2, 0.2, 0.2]);
    ha_comp = axes(hf_comp, 'Color', [0.2, 0.2, 0.2], 'LineWidth', 2, 'XColor', [1 1 1], 'YColor', [1 1 1], 'GridColor', [1 1 1], 'XGrid', 'on', 'YGrid', 'on', 'FontSize', 10);
    hold(ha_comp, 'on');
    plot(ha_comp, t, u, 'w--', 'LineWidth', 1);
    plot(ha_comp, t, y, 'Color', [0.8500    0.3250    0.0980], 'LineWidth', 2);
    plot(ha_comp, t, y_sim, 'w', 'LineWidth', 1);
    title(ha_comp, 'Time Response', 'FontSize', 24, 'Color', [1 1 1], 'FontName', 'Times New Roman');
    ylabel('output [-]', 'FontSize', 18);
    xlabel('time [s]', 'FontSize', 18);
    legend(ha_comp, 'input', 'output', 'identification result', 'Location', 'southwest', 'TextColor', [1 1 1], 'Box', 'off', 'FontSize', 10);
    
    print(hf, './temp_pict/freqresp', '-dpng');
    print(hf_comp, './temp_pict/timeresp', '-dpng');
end