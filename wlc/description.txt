I want to make an app that calculates wage level (in pyton, taking inputs from command line)
the app takes 5 inputs related to the job:
1. Job zone values for this are {Z4, Z5} we will call this Z
2. Education requirements which is a table of degrees and how many years examples are:
	[bachelors, 4
	masters, 2
	phd, 0]
or:
	[bachelors, 2
	masters, 0]
we will call this education experience index or EE
3. Special requirements {0,1,2,3,4} we will call this SR
4. Maneger code {true, false} we will call this MC
5. Have manager responsability {true,false} we will call this MR

The zone values come with a table for Z4 and another table for Z5
Z4 =	2,0
	3,1
	4,2
	>4,3

Z5 =	4,0
	5,0
	6,1
	7,1
	8,2
	9,2
	10,2
	>=11,3
	
you must calculate it for each education year expierience in the EE index
and return the answer this gives the highest wage level value (WL)

The outputs for this are:
WL = {1,2,3,4}
if a wage level is calculated above 4 just make it = 4
i.e. if the result was WL = 5, then make it WL=4



To calculate the wage level (WL) there are the following rules:

1.  we calculate the index education level - min education level
example masters - bachelors = 1
or phd - masters = 1
or phd - bachelors = 2
and add that to the WL value

2. we read the Z value and get the corresponding Z table Z4 or Z5 and
input the years experience based on the degree we are in the index
expience table example masters,2 and input the 2 into the Z table.
This will produce a corresponding wage level increase on the right side of
the Z table, this wage level increase is added to the WL

These steps are repeated for each entry in the EE and the highest value
for WL is used

3. Then we compare the manager code to the MC to the MR, if MC is false
and MR is true, then increase the WL by 1

4. finally add the value of SR to WL to produce a final WL value

Ouput the value
