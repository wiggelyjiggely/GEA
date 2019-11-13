function cust_visualize_results(best_fitness,mean_fitness)
    len = size(transpose(best_fitness));
    subplot(1,3,1);
    plot([1:1:len],mean_fitness(1:len));
    xlabel("Generation");
    ylabel("Mean fitness value");
    hold on;
    subplot(1,3,2);
    plot([1:1:len],best_fitness(1:len));
    xlabel("Generation");
    ylabel("Best fitness value");
    hold on;
end