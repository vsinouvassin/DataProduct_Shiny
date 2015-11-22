# ui.R

shinyUI(fluidPage(
    titlePanel("Employment rate in European Union"),
    
    sidebarLayout(
        sidebarPanel(
            helpText("Create bar plot with employment rate per European country
                     and per sexe for age group 20-64 (Eurostat data)"),
            
            selectInput("var", 
                        label = "Choose a country to display :",
                        choices = c("Austria", "Belgium", "Bulgaria", "Croatia",
                                    "Cyprus", "Czech Republic", "Denmark", "Estonia",
                                    "Finland", "France", "Germany", "Greece",
                                    "Hungary", "Ireland", "Italy", "Lithuania",
                                    "Luxembourg", "Latvia", "Malta", "Netherlands",
                                    "Poland", "Portugal", "Romania", "Slovakia",
                                    "Slovenia", "Spain", "Sweden", "United Kingdom"),
                        selected = "Austria"),
            
            radioButtons("radio", 
                         label = "Choose the sexe to display :",
                         choices = list("Female", "Male",
                                        "Total"),
                         selected = "Total"),
            br(),
            
            em("*Years with no rate in Eurostat data have no bar")
            ),
        
        mainPanel(
            mainPanel(plotOutput("plot"))
        )
    )
))