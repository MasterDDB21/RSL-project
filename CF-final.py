#This page shows a Python code which uses collaborative filtering to create recommendations based on the reviews of a self chosen movie.

# Fill in the favorite movie here (Despicable me is used as example):
favourite_movie = 'despicable-me' 

#First a CSV file with user reviews will be opened and assigned to the variable 'F'. This makes it easy to refer back to the file later on in the code.  
with open('userReviews.csv') as f:
    X = [line.strip().split(';') for     line in f.readlines()]
#The The line above reads in the file in a list called 'X'. The various parts are splitted by the ';'. Line.strip cleans the rows with unnecessary spaces or white lines.
#underneeth is the first line printed, so the names of the columns will be the first row.
print(X[0])
column_names = ['movieName', 'Metascore_w', 'Author', 'AuthorHref', 'Date', 'Summary'
           ,'InteractionsYesCount', 'InteractionsTotalCount', 'InteractionsThumbUp'
           ,'InteractionsThumbDown']

#Y = [row for row in X if row[0] == favourite_movie.lower]
#the line above is the same as the lines below, but in a shorter version. the aim of those lines is to create a list with all the reviews of Despicable Me/ the favourite movie.

Y = []
for row in X:
    if row[0] == favourite_movie and int(row[1]) >= 7:
        Y.append(row)
        Y.append(row)


#now both lists will be combined to create a set of recommendations in a list called 'Z'. 
#Z = [row for row in X if row[2] in [r[2] for r in Y] and row[0] != 'favourite-movie']
Z = [row for row in X 
                  if row[2] in [r[2] for r in Y] 
                  and row[0] != favourite_movie and int(row[1]) >= 7 ]

    
Z.sort(key=lambda x: x[1], reverse=True)

#for row in Z: 
    #print(row) 

# write recommendations to a CSV   file
# Write the recommendations to a CSV file.
with open('recommendations.csv', mode='w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(column_names)  # write column names as first row
    for row in Z:
        writer.writerow([item.strip() for item in row])
