

library(shiny)

shinyServer(function(input, output, session) {
  
  output$table <- DT::renderDataTable({
    datatable(test, rownames = FALSE) %>% 
      formatStyle(input$selected, background = "skyblue", fontWeight = 'bold')
  })
  
  output$delay <- DT::renderDataTable({
    datatable(rest %>% filter(zipcode == input$zipcode) %>% select(zipcode, grade, year) %>% group_by(zipcode, grade, year) %>% summarise(Total = n()), options = list(searching = FALSE))
  })


# Distribution of A/B/C ratings per Borough ####
  output$table3 <- DT::renderDataTable({
    dat = rest %>%
      select(cuisine, grade) %>% 
      group_by(cuisine, grade) %>%
      summarise(Total = n()) %>% 
      arrange(desc(Total))
    
    p <- ggplot(data=dat, aes(x=Total, y=cuisine, fill=grade)) +
      geom_bar(colour="black", stat="identity") +
      guides(fill=FALSE)
    
    ggplotly(p)
  })
  
  # Approval Boxes
  output$appBox <- renderValueBox({
    valueBox(
      "10080", "Least A Ratings", icon = icon("thumbs-down", lib = "glyphicon"),
      color = "yellow"
    )
  })
  
  output$appBox2 <- renderValueBox({
    valueBox(
      "10003", "Most A Ratings", icon = icon("thumbs-up", lib = "glyphicon"),
      color = "blue"
    )
  })
  
  output$appBox3 <- renderValueBox({
    valueBox(
      "10013", "Most C Ratings", icon = icon("thumbs-down", lib = "glyphicon"),
      color = "red"
    )
  })
  
  # How many A/B/C ratings were given by month ####
  output$plot <- renderPlotly({
    plot_ly(
      abc1,
      x = ~ month,
      y = ~ Total,
      name = 'A',
      type = 'scatter',
      mode = 'lines'
    ) %>%
      add_trace(y = ~ Total.1,
                name = 'B',
                mode = 'lines') %>%
      add_trace(y = ~ Total.2,
                name = 'C',
                mode = 'lines')
  })

  # Approval Boxes
  output$appBox4 <- renderValueBox({
    valueBox(
      "48.5%", "Bronx A Ratings", icon = icon("thumbs-up", lib = "glyphicon"),
      color = "green"
    )
  })
  
  output$appBox5 <- renderValueBox({
    valueBox(
      "47%", "Brooklyn A Ratings", icon = icon("thumbs-up", lib = "glyphicon"),
      color = "yellow"
    )
  })
  
  output$appBox6 <- renderValueBox({
    valueBox(
      "48%", "Manhattan A Ratings", icon = icon("thumbs-up", lib = "glyphicon"),
      color = "blue"
    )
  })
  
  output$appBox7 <- renderValueBox({
    valueBox(
      "49%", "Queens A Ratings", icon = icon("thumbs-up", lib = "glyphicon"),
      color = "red"
    )
  })
  
  output$appBox8 <- renderValueBox({
    valueBox(
      "46.%", "Staten Island A Ratings", icon = icon("thumbs-up", lib = "glyphicon"),
      color = "purple"
    )
  })
  
  # Bar graph of A/B/C ratings count per borough ####
  output$year_animation <- renderPlotly({
    g_a = c(15977,43568,68973,40783,5940)
    g_b = c(10394,28896,45727,25295,4303)
    g_c = c(6526,19298,29978,16394,2509)
    nam = c('Bronx', 'Brooklyn', 'Manhattan', 'Queens', 'Staten Island')
    
    gn = data.frame(nam ,g_a, g_b, g_c)
    
    plot_ly(gn, x = ~nam, y = ~g_a, type = 'bar', name = 'A') %>%
      add_trace(y = ~g_b, name = 'B') %>%
      add_trace(y= ~g_c, name = "C") %>% 
      layout(yaxis = list(title = 'Count'), barmode = 'stack')
  })
  
  # Top 20 cuisines and A/B/C rating count ####
  output$gplt <- renderPlotly({
  
    inspections = unique(rest)
  
    cuisine_flitered <- inspections %>%
      group_by(cuisine) %>%
      summarise(count=n()) %>%
      top_n(20, count)
  
    inspectionsFiltered = semi_join(inspections, cuisine_flitered, by = 'cuisine')
  
    gg <- ggplot(data=inspectionsFiltered) +
      geom_bar(aes(x=reorder(cuisine, cuisine, function(x) length(x)), fill=grade), position='dodge') +
      labs(title='Restaurants by cuisine and grade',
           x='Cuisine',
           y='Restaurants') +
      scale_fill_brewer(palette='Set1') +
      coord_flip() + 
      theme_bw() +
      theme(legend.key=element_blank())
  
    ggplotly(gg)
  
  })

})
