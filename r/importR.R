# Libraries Used
require(pacman)

pacman::p_load(vitae, magrittr, readr, glue, tinytex, dplyr, lubridate, here)

# Loads data used and creates transformations

project_data <- function(file){
    data <- here("data", file)
}

# Creates a named vector where the integers for the months correspond to the name of the month
if(file.exists(project_data("Month_Number.RData"))){
    load(file=project_data("Month_Number.RData"))
}else{
    Month.Number <- c(1:12)
    m <- month.name[1]
    for (i in 1:12){
        m <- c(m, month.name[i])
    }
    m <- m[-1]
    names(Month.Number) <- m 
    save(Month.Number, file=project_data("Month_Number.RData"))
}

# Pulls data related to education
edu <- read.csv(project_data("edu.txt"))
# Pulls data related to work
work_text <- read.csv(project_data("work.txt"))
# Pulls data related to the work details or accomplishments
work_details <- read.csv(project_data("work_details.txt"))

# Uses a right join to syn each work achievement to a job title
# May need to be changed in the future if job tittles repeat to a more unique key
work <- work_text %>% right_join(y=work_details, by="title")
# Creates a numerical column for the startMonth
work$Month <- Month.Number[work$startMonth]
# Orders the work data frame reverse chronologically
work <- work[with(work, order(-startYear, -Month)), ]

skills <- read.csv(project_data("skills.txt"))