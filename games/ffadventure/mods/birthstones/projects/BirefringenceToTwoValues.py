import string

try:
	input = raw_input
except NameError:
	pass

print("This program will give you two refraction values with correct " +
	  "birefringence, the average of range you give being the center " +
	  "between the resulting values.")
refraction_range = input("refraction range [a - b format]: ")
birefringence_string = input("birefringence: ")
ref_extremes_strings = refraction_range.split("-")
if len(ref_extremes_strings) == 2:
	ref_extremes = [ float(ref_extremes_strings[0].strip()), 
					float(ref_extremes_strings[1].strip()) ]
	birefringence = float(birefringence_string)
	average = ( ref_extremes[0] + ref_extremes[1] ) / 2.0
	results = [ average - birefringence/2.0,
				average + birefringence/2.0 ]
	print("Results: " + str(results[0]) + "-" + str(results[1]))
else:
	print("refraction range must be in a - b format, such as 1.2-1.31")
	exit(1)
# input("press enter to exit...")

