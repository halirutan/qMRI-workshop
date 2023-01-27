function [magnetization] = e_1(t, t1_val, m_0)
    % E1 take times in same order of magnitude (s, ms, us)
    % basic regaining of longitudinal magnetization
    magnetization = m_0 .* (1 - exp(-t/t1_val));
end