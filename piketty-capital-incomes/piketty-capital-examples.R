# Change to your file path
setwd("~/git/R-projects/piketty-capital-incomes")

# List of packages for session
packages <- c("Quandl", "ggplot2", "ggthemes")

# Install CRAN packages (if not already installed)
.inst <- packages %in% installed.packages()
if(length(packages[!.inst]) > 0) install.packages(packages[!.inst])

# Load packages into session 
sapply(packages, require, character.only = TRUE)

# ggplot2 options
theme_set(theme_minimal(base_family = "Helvetica Neue", base_size = 12))
source('~/git/R-projects/ODI-colours.R') # Official ODI brand colours

# Access with your token
# More help http://www.quandl.com/help/r
Quandl.auth("yourauthenticationtoken")

ratio_world <- Quandl('PIKETTY/TS12_4A')

# Plot figure 12.4 world capital/income ratio
f12.4 <- ggplot() + 
  geom_point(data = ratio_world, aes(x = Date, y = World), shape = 15) + 
  geom_line(data = ratio_world[ratio_world$Date <= as.Date('2010-12-31'), ], aes(x = Date, y = World)) +
  geom_line(data = ratio_world[ratio_world$Date >= as.Date('2010-12-31'), ], aes(x = Date, y = World), linetype = 'dotted') +
  annotate('text', x = as.Date('2013-01-01'), y = 700, label = 'Projections', size = 4) +
  annotate('text', x = as.Date('2020-01-01'), y = 640, label = '(central scenario)', size = 4) +
  xlab('The world capital/income ratio might be near to 700% by the end of the 21st century.') +
  ylab('Value of private capital (% world income)') +
  theme(axis.title = element_text(size = 10)) + 
  ylim(0, 800) +
  ggtitle('Figure 12.4. The world capital/income ratio, 1870-2100')

# Economist
f12.4 + theme_economist() + theme(axis.title.x = element_text(vjust = -0.5)) + theme(axis.title.y = element_text(vjust = 0.25))
ggsave("graphics/figure-12-4-economist.png", height = 4, width = 8, dpi = 100)
 
# Stata
f12.4 + theme_stata() + theme(axis.title.x = element_text(vjust = -0.5)) + theme(axis.title.y = element_text(vjust = 0.25))
ggsave("graphics/figure-12-4-stata.png", height = 4, width = 8, dpi = 100)

# Fivethirtyeight
f12.4 + theme_fivethirtyeight() + theme(axis.title = element_text(size = 10), axis.title.y = element_text(angle = 90, vjust = 0.25)) + theme(axis.title.x = element_text(vjust = -0.5))
ggsave("graphics/figure-12-4-538.png", height = 4, width = 8, dpi = 100)

# ODI, replicated for a nice colour
ggplot() + 
  geom_point(data = ratio_world, aes(x = Date, y = World), shape = 15, color = odi_dPink) + 
  geom_line(data = ratio_world[ratio_world$Date <= as.Date('2010-12-31'), ], aes(x = Date, y = World), color = odi_dPink) +
  geom_line(data = ratio_world[ratio_world$Date >= as.Date('2010-12-31'), ], aes(x = Date, y = World), color = odi_dPink, linetype = 'dotted') +
  annotate('text', x = as.Date('2013-01-01'), y = 700, label = 'Projections', size = 4) +
  annotate('text', x = as.Date('2020-01-01'), y = 640, label = '(central scenario)', size = 4) +
  xlab('The world capital/income ratio might be near to 700% by the end of the 21st century.') +
  ylab('Value of private capital (% world income)') +
  theme(axis.title = element_text(size = 10)) + 
  theme(axis.title.x = element_text(vjust = -0.5)) + 
  theme(axis.title.y = element_text(vjust = 0.25)) + 
  ylim(0, 800) + 
  ggtitle('Figure 12.4. The world capital/income ratio, 1870-2100')
ggsave("graphics/figure-12-4-world-capital-income-ratio.png", height = 4, width = 8, dpi = 100)
