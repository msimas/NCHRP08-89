oms <- read.csv("Output/Mode Transition Identification/300files/Oliveira_generated.csv")
tms <- read.csv("Output/Mode Transition Identification/300files/TsuiShalaby_SchuesslerAxhausen_generated.csv")

qplot(travtimeminutes, data=oms, colour=I("cyan"), fill=I("blue"), xlim=c(0,100), xlab="Travel Time (minutes)", ylim=c(0,1250))
ggsave(filename="oliveira_ms.png", dpi=150)

qplot(travtimeminutes, data=tms, colour=I("cyan"), fill=I("blue"), xlim=c(0,100), xlab="Travel Time (minutes)", ylim=c(0,1250))
ggsave(filename="tsui_ms.png", dpi=150)