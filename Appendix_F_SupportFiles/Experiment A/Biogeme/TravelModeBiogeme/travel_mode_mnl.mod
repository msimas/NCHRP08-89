// File: mode_mnl.mod				
// Author: Marcelo Simas Oliveira, Westat				
// Date: May 22 2013				
//				
// Logit model				
// Five alternatives: 1 walk	2 bike	3 auto/van/truck driver	5 local bus	7 MARTA train
// GPS Mode Segment data				
				
[ModelDescription]				
//Logit model for identifying travel mode from GPS point attributes.				
				
[Choice]				
travmode				
				
[Beta]				
// Name Value  LowerBound UpperBound  status (0=variable, 1=fixed)				
asc_walk	0	-10000	10000	0
asc_bike	0	-10000	10000	0
asc_auto	0	-10000	100	0
asc_bus	0	-10000	10000	0
asc_train	0	-10000	10000	0

walk_lowspeed	0	-10000	10000	0
bike_lowspeed	0	-10000	10000	0
bike_midspeed	0	-10000	10000	0

auto_midspeed	0	-10000	10000	0
auto_highspeed	0	-10000	10000	0
bus_midspeed	0	-10000	10000	0
bus_highspeed	0	-10000	10000	0
train_highspeed	0	-10000	10000	0
train_higherspeed	0	-10000	10000	0

walk_lowaccel	0	-10000	10000	0
bike_midaccel	0	-10000	10000	0
auto_highaccel	0	-10000	10000	0
auto_higheraccel	0	-10000	10000	0
bus_highaccel	0	-10000	10000	0
bus_higheraccel	0	-10000	10000	0
train_highaccel	0	-10000	10000	0
				
[Utilities]				
// Id Name     Avail       linear-in-parameter expression (beta1*x1 + beta2*x2 + ... )				
1	walk	one	asc_walk * one + walk_lowspeed * lowspeed + walk_lowaccel * lowaccel
2	bike	one	asc_bike * one + bike_lowspeed * lowspeed + bike_midspeed * midspeed + bike_midaccel * midaccel
3	auto	one	asc_auto * one + auto_midspeed * midspeed + auto_highspeed * highspeed + auto_highaccel * highaccel + auto_higheraccel * higheraccel
5	bus	one	asc_bus * one + bus_midspeed * midspeed + bus_highspeed * highspeed + bus_highaccel * highaccel + bus_higheraccel * higheraccel
7	train	one	asc_train * one + train_highspeed * highspeed + train_higherspeed * higherspeed + train_highaccel * highaccel
				
[Expressions] 				
// Define here arithmetic expressions for name that are not directly 				
// available from the data				
one = 1				
lowspeed = avgspeedmph < 7.5
midspeed = avgspeedmph >= 7.5 && avgspeedmph < 15
highspeed = avgspeedmph >= 15
higherspeed = avgspeedmph >= 30

lowaccel = sdaccelmps2 < 0.125
midaccel = sdaccelmps2 >= 0.125 && sdaccelmps2 < 0.375
highaccel = sdaccelmps2 >= 0.375
higheraccel = sdaccelmps2 >= 0.5


				
[Model]				
// $MNL stands for multinomial logit model, 				
$MNL				
