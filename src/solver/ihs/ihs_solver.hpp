#pragma once

#include "solver/solver.hpp"

namespace mofjssp {
/*******************************************************
 * The IHS_Solver represents a solver for the
 * Multi-Objective Flexible Job Shop Scheduling Problem
 * using the Improved Harmony Search.
 *******************************************************/
class IHS_Solver : public Solver {
    public:
    /*******************************
     * Size of the population.
     *******************************/
    unsigned population_size = 128;

    /***************************************
     * Probability of choosing from memory.
     ***************************************/
    double phmcr = 0.98931;

    /*********************************
     * Minimum pitch adjustment rate.
     *********************************/
    double ppar_min = 0.248173;

    /*********************************
     * Maximum pitch adjustment rate.
     *********************************/
    double ppar_max = 0.871622;

    /******************************
     * Minimum distance bandwidth.
     ******************************/
    double bw_min = 0.007596;

    /******************************
     * Maximum distance bandwidth.
     ******************************/
    double bw_max = 0.263619;

    /*********************************************
     * Constructs a new solver.
     *
     * @param instance the instance to be solved.
     *********************************************/
    IHS_Solver(const Instance & instance);

    /*********************************
     * Constructs a new empty solver.
     *********************************/
    IHS_Solver();

    /**********************
     * Solve the instance.
     **********************/
    void solve();

    /***************************************************************
     * Standard stream operator.
     *
     * @param os the standard output stream object.
     * @param solver the solver.
     *
     * @return the stream object.
     ***************************************************************/
    friend std::ostream & operator <<(std::ostream & os,
                                      const IHS_Solver & solver);
};

}
