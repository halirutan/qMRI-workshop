function [signal] = t1_relaxation(t, t1_val, m_0)
% T1_RELAXATION standard model describing the relaxation of longitudinal magnetization
signal = - m_0 .* exp(-t/t1_val) + e_1(t, t1_val, m_0);
end
