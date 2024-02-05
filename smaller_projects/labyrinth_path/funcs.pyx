import numpy as np
cimport numpy as np
np.import_array()

DTYPE = np.int

ctypedef np.int_t DTYPE_t

ctypedef (int, int) Position

cdef np.ndarray labirynth = np.array([[1,1,1,1,1,1,1,1,1,1,1,1],
                        [1,0,0,0,1,0,0,0,1,0,0,1],
                        [1,1,1,0,0,0,1,0,1,1,0,1],
                        [1,0,0,0,1,0,1,0,0,0,0,1],
                        [1,0,1,0,1,1,0,0,1,1,0,1],
                        [1,0,0,1,1,0,0,0,1,0,0,1],
                        [1,0,0,0,0,0,1,0,0,0,1,1],
                        [1,0,1,0,0,1,1,0,1,0,0,1],
                        [1,0,1,1,1,0,0,0,1,1,0,1],
                        [1,0,1,0,1,1,0,1,0,1,0,1],
                        [1,0,1,0,0,0,0,0,0,0,0,1],
                        [1,1,1,1,1,1,1,1,1,1,1,1]])
cdef Position goal_pos = (10,10)
cdef Position starting_pos = (1,1)
cdef int labirynth_x = labirynth.shape[0]
cdef int labirynth_y = labirynth.shape[1]

cpdef int fitness_func(np.ndarray[dtype=int] solution, int solution_idx):
    cdef int fitness = 100
    cdef dict moves = {0:(0,1),1:(0,-1),2:(1,0),3:(-1,0)}
    cdef Position pos = starting_pos
    cdef set visited_pos = set()
    visited_pos.add(pos)
    for gene in solution:
        prev_pos = pos
        pos = (pos[0]+moves[gene][0],pos[1]+moves[gene][1])
        (pos_y,pos_x)=pos
        if any([pos_y < 0, pos_y >= labirynth_x, pos_x < 0, pos_x >= labirynth_y]):
            return 0 # out of bounds
        if labirynth[pos_y][pos_x] == 1:
            fitness -= 10
            pos = prev_pos # stay in place if hit a wall
        else:
            if pos == goal_pos:
                fitness += 150
                break # reached goal
            if pos in visited_pos:
                fitness -= 5 # visited this position before
            else:
                fitness += 2 # new position
        visited_pos.add(pos)
    return fitness