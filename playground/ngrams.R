require(ngramr)
require(ggplot2)

# case-insensitive search
bars <- ngrami(c("bar chart", "bar graph"), year_start = 1913)
lines <- ngrami(c("line chart", "line graph"), year_start = 1913)

ggplot(lines, aes(Year, Frequency, colour = Phrase)) + theme_minimal() + geom_line(lwd = 1)