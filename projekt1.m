x = [0:1:1200]
y = square(0.01.*x);
for i = 1:length(y)
    sign = rand();
    noise = rand();
    if sign > 5
        y(i) = y(i) + 0.1*noise;
    else
        y(i) = y(i) - 0.1*noise;
    end
end
plot(x, y);