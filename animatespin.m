% magnitude in the unit of gamma*h_bar
mu = 1/2;
% set the initial direction in terms of polar and azimuthal angles
% polar angle
theta = pi/6;
% azimuthal angle
phi = 0;
% compute the Cartesian components of the vector
vecMu = mu*[cos(phi)*sin(theta) sin(phi)*sin(theta) cos(theta)]';

% set the precession frequency relative to the Larmor frequency
% in the unit of radian*kHz
omega = 2*pi;
% set the time increment (in the unit of ms)
deltaT = 0.01;
% set the number of time increments to animate
noOfSteps = 200;

figure;
h1 = subplot(2,2,1);
hold on;
axis equal;
view(100, 10);
xlabel('\mu_x');
ylabel('\mu_y');
zlabel('\mu_z');
xlim([-0.5 0.5]);
ylim([-0.5 0.5]);
zlim([0 0.5]);
grid on;

h2 = subplot(2,2,2);
hold on;
xlabel('\mu_x');
ylabel('\mu_y');
xlim([-0.5 0.5]);
ylim([-0.5 0.5]);
grid on;
axis square

h3 = subplot(2,2,3);
hold on;
xlabel('time (ms)');
ylabel('\mu_x');
xlim([0, noOfSteps*deltaT]);
ylim([-0.5 0.5]);
grid on;

axis square
h4 = subplot(2,2,4);
hold on;
xlabel('time (ms)');
ylabel('\mu_y');
xlim([0, noOfSteps*deltaT]);
ylim([-0.5 0.5]);
grid on;

angle = omega*deltaT;

rot = [cos(angle) sin(angle) 0; -sin(angle) cos(angle) 0; 0 0 1];

for i=0:noOfSteps-1
    % plot the current vector in figure h1
    % function PlotSpin3D provided below
    hVecMu = plotSpin3D(h1, vecMu);
    
    % plot the transverse components in figure h2
    hTransverseMu = plotSpinTransverse(h2, vecMu);

    % plot the x and y components in figures h3 and h4
    plot_comp(h3, i*deltaT, vecMu(1));
    plot_comp(h4, i*deltaT, vecMu(2));

    % pause
    pause(0.05);

    % clear the vector and the transverse components
    delete(hVecMu);
    delete(hTransverseMu);

    % plot the current spin vector to keep
    plotSpin3D(h1, vecMu, ['c', 'r']);
    plotSpinTransverse(h2, vecMu, ['c', 'r']);
    % update the spin vector
    vecMu = rot*vecMu;
end

plotSpin3D(h1, vecMu);
plotSpinTransverse(h2, vecMu);


function objHandle = plotSpin3D (figHandle, vecMu, colors)
    % function objHandle = plotSpin3D (figHandle, vecMu)
    % a function for plotting the magnetic moment vector of a spin
    %
    % INPUT:
    %   figHandle - the handle to the figure for plotting
    %   vecMu – the magnetic moment vector (3-by-1) to plot
    %   colors – a 2-by-1 character array: the 1st entry storing the color for 
    %            the stem of the vector, and the 2nd for the tip of the vector
    %
    % OUTPUT:
    %   objHandle – the handle to the plotted magnetic moment
    %
    % author: Gary Zhang (gary.zhang@ucl.ac.uk)
    %
    % for UCL COMP0121: Computational MRI
    %
    % If the 3rd argument is not provided, set the color vector to some default
    % choice
    if nargin < 3
        colors = ['b', 'r'];
    end
    
    % Plot the stem of the vector
    objHandle(1) = plot3(figHandle, [0 vecMu(1)], [0 vecMu(2)], ...
        [0 vecMu(3)], 'Color', colors(1), 'LineStyle', '-', 'LineWidth', 2);
    
    % Plot the tip of the vector
    objHandle(2) = plot3(figHandle, vecMu(1), vecMu(2), vecMu(3), ...
        'Color', colors(2), 'Marker', '.', 'MarkerSize', 10);
end

function objHandle = plotSpinTransverse(figHandle, vecMu, colors)
    if nargin < 3
        colors = ['b', 'r'];
    end
    
    % Plot the stem of the transverse vector (x and y components only)
    objHandle(1) = plot(figHandle, [0 vecMu(1)], [0 vecMu(2)], ...
        'Color', colors(1), 'LineStyle', '-', 'LineWidth', 2);
    
    % Plot the tip of the transverse vector
    objHandle(2) = plot(figHandle, vecMu(1), vecMu(2), ...
        'Color', colors(2), 'Marker', '.', 'MarkerSize', 10);
end

function objHandle = plot_comp(figHandle, t, comp, colors)
    if nargin < 4
        colors = ['b', 'r'];
    end
    
    % Plot current point (x and y components only)
    objHandle = plot(figHandle, t, comp, 'Color', colors(1), 'Marker', '.');
end
    



