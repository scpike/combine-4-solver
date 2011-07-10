#!/usr/bin/ruby

potentials = ([1,2,3,4,5,6,7,8,9,10,11,12,13]*4).combination(4).collect


for potential in potentials
 puts potential.inspect
end

