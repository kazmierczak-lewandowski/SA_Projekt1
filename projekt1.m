close all;
clear all;
t = 1000;
a = [1; 6; 4];

u = 2.*rand(1,t+2);
zk = rand(1, t+2)-0.5;

figure
    hold on;
    title("Wejscie");
    xlabel('Czas');
    ylabel('Wartosc');
    grid on;
    plot(u);
    xlim([0, 1000]);
    ylim([-1, 3])
    hold off;
Y = zeros(1, t);
Fi = zeros(t, 3);
%Offline
for i = 3:t+2
    fi = [u(i), u(i-1), u(i-2)];
    Y(i-2) = fi * a + zk(i);
    Fi(i-2, :) = fi;
end

figure
    hold on;
    title("Wyjscie");
    xlabel('Czas');
    ylabel('Wartosc');
    grid on;
    plot(Y);
    xlim([0, 1000]);
    ylim([0, 25])
    hold off;
    
%Online
result = zeros(1000, 3);
Pk = [1000, 0, 0; 0, 1000, 0; 0, 0, 1000];
aon = [0; 0; 0];
for i = 3:t+2
    fi = [u(i); u(i-1); u(i-2)];
    y = fi' * a + zk(i);
    Pk = Pk - ((Pk * fi * fi' * Pk)/(1 + fi' * Pk * fi));
    aon = aon + (Pk * fi * (y' - fi' * aon));
    result(i-2, :) = aon;
end

figure
    hold on;
    title("Wartości estymowane parametrów w czasie");
    xlabel('Czas');
    ylabel('Wartoci parametrów');
    grid on;
    xlim([0, 500]);
    plot(result(:, 1), '-r')
    plot(result(:, 3), '-g')
    plot(result(:, 2), '-b')
    yline(a(1), '--', 'Color', [0, 0, 0]);
    yline(a(2), '--', 'Color', [0, 0, 0]);
    yline(a(3), '--', 'Color', [0, 0, 0]);
    hold off;

%Zapominanie
j = 1;
lambdaResult = zeros(21, 2);
for lambda = 0.97:0.001:0.99
    Pk = [1000, 0, 0; 0, 1000, 0; 0, 0, 1000];
    afo = [0; 0; 0];
    res = zeros(3, 1);
    for i = 3:t+2
        a(:, i-2) = [1 + 0.1 * square(0.01 * (i-2)); 6; 4];
        fi = [u(i); u(i-1); u(i-2)];
        y = fi' * a(:, i-2) + zk(i);
        Pk = Pk - ((Pk * fi * fi' * Pk)/(lambda + fi' * Pk * fi));
        Pk = Pk / lambda;
        afo = afo + (Pk * fi * (y' - fi' * afo));
        result(i-2, :) = afo;
        tmp = a(:, i-2) - afo;
        tmp = tmp .* tmp;
        res = res + tmp;
    end
    lambdaResult(j, :) = [lambda, mean(res)];
    j = j + 1;
end
[~, idx] = min(lambdaResult(:,2));
lambda = lambdaResult(idx, 1);
Pk = [1000, 0, 0; 0, 1000, 0; 0, 0, 1000];
afo = [0; 0; 0];
for i = 3:t+2
    a(:, i-2) = [1 + 0.1 * square(0.01 * (i-2)); 6; 4];
    fi = [u(i); u(i-1); u(i-2)];
    y = fi' * a(:, i-2) + zk(i);
    Pk = Pk - ((Pk * fi * fi' * Pk)/(lambda + fi' * Pk * fi));
    Pk = Pk / lambda;
    afo = afo + (Pk * fi * (y' - fi' * afo));
    result(i-2, :) = afo;
end
figure
        hold on;
        title("Wartości estymowane parametrów w czasie dla lambda=" + lambda);
        xlabel('Czas');
        ylabel('Wartoci parametrów');
        grid on;
        plot(result(:, 1), '-r')
        plot(result(:, 3), '-g')
        plot(result(:, 2), '-b')
        plot(a(1, :), '--', 'Color', [0, 0, 0])
        yline(a(2), '--', 'Color', [0, 0, 0]);
        yline(a(3), '--', 'Color', [0, 0, 0]);
        hold off;
