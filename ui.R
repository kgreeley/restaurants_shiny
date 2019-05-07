#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)

shinyUI(dashboardPage(skin = "purple",
  dashboardHeader(title = "Restaurant Grade"),
  dashboardSidebar(
    sidebarUserPanel("Kyle Greeley"),
    sidebarMenu(
      menuItem("About", tabName = "About"),
      menuItem("Borough", tabName = "Borough"),
      menuItem("Cuisine", tabName = "Cuisine"),
      menuItem("Zipcode", tabName = "Zipcode"),
      menuItem("Grade", tabName = "Grade"),
      menuItem("Search", tabName = "Search")
    )),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "About",
              h2('What Is In A Restaurant Grade?', align = "center"),
              br(),
              h4("New York City is constantly monitoring and upgrading the restaurant grade from across all 5 boroughs from the past 6 years. This Shiny app is to
                make it easier for the consumer to read about their restaurant of choice. I want you to know what the restaurant has received for a grade and previous/current violations.
                 As a consumer, I'd want to know the history of my favorite restaurants. Have they improved over the years and what did they have to fix? Why was their grade change?
                 These are some of the answer that we'd have to serach for ourselves."),
              br(),
              img(src = "http://cdn2.vox-cdn.com/uploads/chorus_asset/file/861328/kn_20ramsay_20and_20antiques.0.jpg", width = "83%")),
      tabItem(tabName = "Borough",
              h2('Percent of Ratings by Borough'),
              fluidRow(infoBoxOutput("appBox4"),
              infoBoxOutput("appBox5"),
              infoBoxOutput("appBox6"),
              infoBoxOutput("appBox7"),
              infoBoxOutput("appBox8")),
              br(),
              plotlyOutput("year_animation")),
      tabItem(tabName = "Cuisine",
              h2('Top Cuisine by Inspection Grade', align = "center"),
              fluidPage(plotlyOutput("gplt", width = "1100", height = "700"))),
      tabItem(tabName = "Zipcode",
              h2('Restaurant Grade by Zipcode'),
              fluidRow(infoBoxOutput("appBox"),
                       infoBoxOutput("appBox2"),
                       infoBoxOutput("appBox3")),
              fluidRow(column(width = 1),
                       column(width = 2, title = "Select Your Zipcode!", solidHeader = TRUE, status = "primary",
                              selectInput(inputId = "zipcode", label = '', choices = sort(unique(rest$zipcode)),
                                          selected = NULL, multiple = FALSE),
                              DT::dataTableOutput("delay")))),
      tabItem(tabName = "Grade",
              h2('Monthly Review Grades'),
              br(),
              fluidPage(
                plotlyOutput("plot"),
                verbatimTextOutput("Test-run")
              )),
      tabItem(tabName = "Search", 
              fluidRow(box(DT::dataTableOutput("table"),width = 12)))
    )
    )
))

