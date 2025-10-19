NOISE_STRENGTH=0.9;
H_NUMBER = 20;
STRETCH = 0.01;
X_NUMBER = 1200;
x = 0:1:X_NUMBER;
y = square(STRETCH.*x);
z = zeros(1, X_NUMBER + 1);
figure
    title("Input")
    plot(x,y)
    ylim([-1.5, 1.5]);
    
for i = 1:length(y)
    sign = rand();
    noise = NOISE_STRENGTH * rand();
    if sign > 0.5
        z(i) = y(i) + noise;
    else
        z(i) = y(i) - noise;
    end
end

figure
    title("InputNoise")
    plot(x, z)
    ylim([(-1-NOISE_STRENGTH)-0.5, 1+NOISE_STRENGTH+0.5])
dH = nan(1, H_NUMBER);
out = zeros(1, X_NUMBER + 1);
for h = 1:H_NUMBER
    H = zeros(1, X_NUMBER + 1);
    for xk = 1:length(x)
        avg = z(xk);
        count = 0;
        for i = 1:h
            if xk-i < 1
                count = count + 1;
                continue;
            end
            avg = avg + z(xk-i);
        end
        H(xk) = avg / (h - count + 1);
    end
    V = 0;
    for xk = 1:length(x)
        tmp = H(xk) - y(xk);
        V = V + (tmp * tmp);
    end
    dH(h) = V / length(y);
    if dH(h) == min(dH)
        out = H;
    end
end

h = 1:1:H_NUMBER;
figure
    plot(x, out)
figure
    plot(h, dH)
    xlim([0, H_NUMBER])
    ylim([min(dH) * 0.9, dH(H_NUMBER) * 1.1])
