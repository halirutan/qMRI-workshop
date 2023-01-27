function [magnetization] = t1_ir_rho(t, t1_val, rho, m_initial)
    % T1_IR_RELAXATION
    % use either both times in seconds or ms
    % inversion flip angle defines starting magnetization
    % 180° completely flips magnetization, rho describes efficiency of the pulse.
    m_start = m_initial * cos(radians(rho * 180.0));
    magnetization = m_start .* exp(-t / t1_val) + e_1(t, t1_val, 1.0);
end

