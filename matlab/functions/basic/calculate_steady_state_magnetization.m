function [m_ss] = calculate_steady_state_magnetization(t1_val, tr_val, rho)
    % calculate "available" magnetization due to insufficient relaxation,
    % like in an experiment this settles after a few repetitions (starting with 1)
    m_0 = 1.0;
    m_ss_last = t1_ir_rho(tr_val, t1_val, rho, m_0);
    m_ss = t1_ir_relaxation(tr_val, t1_val, rho, m_ss_last);
    while abs(m_ss - m_ss_last) > 1e-6
        m_ss_last = m_ss;
        m_ss = t1_ir_relaxation(tr_val, t1_val, rho, m_ss_last);
    end
end
