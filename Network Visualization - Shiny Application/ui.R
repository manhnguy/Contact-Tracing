## ui.R ##


# ui consists of a header, a sidebar and a body.

####### Header ######
header <- dashboardHeader( title = "Visualize contacts" )


####### Sidebar ######
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Load data", tabName = "loaddata"
    ),

    menuItem("Contact network",
             tabName = "network"),

    #menuItem("Estimate incubation time", tabName = "inctime",
     #        badgeLabel = "new", badgeColor = "green"),

   menuItem("Map", tabName = "map")
  )
)

####### Body ######
body <- dashboardBody(
  
  tabItems(

        ##### Tab 1: Load data #####
    tabItem(tabName = "loaddata",
            h2(""), # Title

            fluidRow(

              # image
      #      tabBox(width = 12,
      #    #  tags$img(src = "Timeline_diagram.jpg"),
      #      imageOutput('image')
      #      ),

            tabBox(width = 6, title = "Step 1", tabPanel("Load the data.",
            # Select a data set
            fileInput(width = 400, inputId = "file1",
                      label = "Select a RDS file with contact tracing data to import.", accept = ".rds"
            )
            )
            ),

            # https://stackoverflow.com/questions/65587869/r-shiny-how-to-box-a-simple-text-on-a-shiny-page
            tabBox(width = 6, title = "Getting started in three steps.",
                   p("The aim of this application is to visualize contact tracing data, facilitating data cleaning and processing steps. Before you move on to the other tabs, import a data set in .RDS format. To save data as .RDS file, use"),
                   code("saveRDS(data)."),
                   p("If everything is correct, the data table should show up. Next, select the required variables. All ID variables need to be in text format; dates need to be in the date format. To check if the format is correct, use the following R functions:"),
                   code("type <- class(data$variable_name); is.Date(type); is.character(type); is.factor(type)")
            )

            ),

            fluidRow(

            # Box 1/1
            tabBox(width = 6, title = "Step 2",
                   tabPanel("Check if contact tracing data is imported correctly.", dataTableOutput("table")),
            ),


            tabBox(width = 6, title = "Step 3", tabPanel("Choose variables.",

            # Choose a variable to base the color coding of network nodes on.
            selectizeInput(width = 400,
            'case_var', 'IDs of the infectees:',
            choices = list(),
            multiple = FALSE
            ),

            # Choose a variable to base the color coding of network nodes on.
            selectizeInput(width = 400,
              'infector_var', 'IDs of infector(s), i.e. possible sources:',
              choices = list(),
              multiple = FALSE
            ),

            ######
            # Choose a variable for start of exposure.
            selectizeInput(width = 400,
                           'start_of_exposure', 'Start of exposure (E0):',
                           choices = list(),
                           multiple = FALSE
            ),

            # Choose a variable for end of exposure.
            selectizeInput(width = 400,
                           'end_of_exposure', 'End of exposure (E1)',
                           choices = list(),
                           multiple = FALSE
            ),

            # Choose a variable for symptom onset.
            selectizeInput(width = 400,
                           'symptom_onset', 'Symptom onset (S)',
                           choices = list(),
                           multiple = FALSE
            ),
            ########

            # Choose a variable for last negative test.
            selectizeInput(width = 400,
                           'last_negative', 'Last negative test (P0)',
                           choices = list(),
                           multiple = FALSE
            ),
            ########

            # Choose a variable for first positive test.
            selectizeInput(width = 400,
                           'first_positive', 'First positive test (P1)',
                           choices = list(),
                           multiple = FALSE
            )
            ########

            ))
    )


    ),


  tabItem(tabName = "network",

    fluidRow(

      # Box 1/1
      tabBox(width = 6, tabPanel("Settings",

                                  # Choose a variable to base the color coding of network nodes on.
                                  selectizeInput(
                                    'nodecol', 'Color network nodes by:',
                                    choices = list(),
                                    multiple = FALSE
                                  ),

                                  # Check or uncheck incubation time/latency time
                                  checkboxInput('show_symptoms', "Incubation time (infection to symptom onset)", value = TRUE, width = NULL),
                                  checkboxInput('show_testwindow', "Latency time (here: infection to PCR positivity)", value = TRUE, width = NULL)

      )

      ),


      # https://stackoverflow.com/questions/65587869/r-shiny-how-to-box-a-simple-text-on-a-shiny-page
      tabBox(width = 6, title = "Description",
             p("The network graph displays the possible transmission between infectee and potential sources. Each arrow represents one possible infection, from infector to infectee. To select a cluster of cases to display in the timeline figure on the right and the table below, click on a central case in the network for two seconds."),
             p("The figure below visualizes the time of the start- end endpoint for selected observations. Start- and endpoint differs per quantity of interest, i.e. incubation or latency time. Time of infection is typically known to fall in a certain window only. The same holds for start of infectiousness, that is assumed to occur in between the last negative and first positive PCR-test. Start and and of the window are represented by a '0' and '1', respectively. When these are not displayed, they are missing in the data."),

      )

    ),


    fluidRow( # row 2/3

            # Box 1/2
            tabBox(
              tabPanel("Network", visNetworkOutput("network"))
            ),

            # Box 2/2
            tabBox(
              tabPanel("Figure", plotlyOutput("timeline")
                       )
            )

  ),

  fluidRow( # row 3/3

            # Box 1/1
            tabBox(width = 12,
              tabPanel("Table", dataTableOutput("table_selected_nodes"))
            )

            )


  ), # End tabItem
    
 tabItem(tabName = "map",
         fluidRow(
           tabBox(width = 12,
                  tabPanel("Map Network", leafletOutput("drawmap", height = 1000))
                  )
           )
         )
    
  ) # End tabitems
  
  ) # End dashboardbody

####### Combine ######
ui <- dashboardPage(
  header,
  sidebar,
  body
)

