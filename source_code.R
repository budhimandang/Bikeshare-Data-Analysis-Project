install.packages("tidyverse")
install.packages("dplyr")
install.packages("janitor")
install.packages("skimr")
library("tidyverse")
library("dplyr")
library("skimr")
library("janitor")

setwd("C:/Users/91828/Documents/BDANG/4282234/excel data")

march_csv<-read_csv("march_2020.csv")
april_csv<-read_csv("april_2020.csv")
may_csv<-read_csv("may_2020.csv")
jun_csv<-read_csv("jun_2020.csv")
jul_csv<-read_csv("jul_2020.csv")
aug_csv<-read_csv("aug_2020.csv")
sep_csv<-read_csv("sep_2020.csv")
oct_csv<-read_csv("oct_2020.csv")
nov_csv<-read_csv("nov_2020.csv")
dec_csv<-read_csv("dec_2020.csv")
jan21_csv<-read_csv("jan_2021.csv")
feb21_csv<-read_csv("feb_2021.csv")

compare_df_cols(march_csv,april_csv,may_csv,jun_csv,jul_csv,aug_csv,sep_csv,oct_csv,nov_csv,dec_csv,jan21_csv,feb21_csv,return="mismatch")

march_csv<-mutate(march_csv,end_station_id=as.numeric(end_station_id),start_station_id=as.numeric(start_station_id))
dec_csv<-mutate(dec_csv,end_station_id=as.numeric(end_station_id),start_station_id=as.numeric(start_station_id))
jan21_csv<-mutate(jan21_csv,end_station_id=as.numeric(end_station_id),start_station_id=as.numeric(start_station_id))
feb21_csv<-mutate(feb21_csv,end_station_id=as.numeric(end_station_id),start_station_id=as.numeric(start_station_id))

compare_df_cols(march_csv,april_csv,may_csv,jun_csv,jul_csv,aug_csv,sep_csv,oct_csv,nov_csv,dec_csv,jan21_csv,feb21_csv,return="mismatch")

compiled_ride_data_unclean<-rbind(march_csv,april_csv,may_csv,jun_csv,jul_csv,aug_csv,sep_csv,oct_csv,nov_csv,dec_csv,jan21_csv,feb21_csv)

compiled_ride_data_clean<-compiled_ride_data_unclean %>%
  select(-c(start_lat, start_lng, end_lat, end_lng))

colnames(compiled_ride_data_clean)

compiled_ride_data_clean<-compiled_ride_data_clean %>%
  rename(bike_type=rideable_type,
         start_time=started_at,
         end_time=ended_at,
         from_station_name=start_station_name,
         to_station_name=end_station_name,
         from_station_id=start_station_id,
         to_station_id=end_station_id,
         rider_type=member_casual)


colnames(compiled_ride_data_clean)
View(compiled_ride_data_clean)

dim(compiled_ride_data_clean)

head(compiled_ride_data_clean)

str(compiled_ride_data_clean)

summary(compiled_ride_data_clean)

skim(compiled_ride_data_clean)

compiled_ride_data_clean$date<-as.Date(compiled_ride_data_clean$start_time)
compiled_ride_data_clean$year<-format(as.Date(compiled_ride_data_clean$date),"%Y")
compiled_ride_data_clean$month<-format(as.Date(compiled_ride_data_clean$date),"%m")
compiled_ride_data_clean$day<-format(as.Date(compiled_ride_data_clean$date),"%d")
compiled_ride_data_clean$week<-format(as.Date(compiled_ride_data_clean$date),"%A")

View(compiled_ride_data_clean)

colnames(compiled_ride_data_clean)
compiled_ride_data_clean<-compiled_ride_data_clean %>%
  rename(day_of_week=week)

compiled_ride_data_clean$ride_length<-difftime(compiled_ride_data_clean$end_time,compiled_ride_data_clean$start_time)

is.numeric(compiled_ride_data_clean$ride_length)
is.factor(compiled_ride_data_clean$ride_length)

compiled_ride_data_clean$ride_length<-as.numeric(as.character(compiled_ride_data_clean$ride_length))

is.numeric(compiled_ride_data_clean$ride_length)

skim(compiled_ride_data_clean$ride_length)

compiled_ride_data_clean_new<-compiled_ride_data_clean[!compiled_ride_data_clean$ride_length<0,]

skim(compiled_ride_data_clean_new)

summary(compiled_ride_data_clean_new$ride_length)

write.csv(compiled_ride_data_clean_new,"merge_clean_data.csv")

