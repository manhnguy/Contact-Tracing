

server <- shinyServer(function(input, output, session) {

    # Begin of server

output$image <- renderImage({
    list(src =  "Timeline_diagram.jpeg",
         alt = "This is alternate text",  height = 400, width = 400
    )
  }, deleteFile = TRUE)

  output$text <- renderText({ input$txt })

  output$text2 <- renderText({ input$txt2 })

  ##### Load the data. #####

  mydat <- reactive({
    req(input$file1)
    readRDS(input$file1$datapath)
  })

  selected_data <- reactive({
    as.data.frame(dat_for_tab())
  })

  ##### Inputs for subset ####

  observe({  # The drop-down menu depends on data set.
    updateSelectizeInput(session, "nodecol",
                         choices = names(selected_data()))
  })

  observe({  # The drop-down menu depends on data set.
    updateSelectizeInput(session, "infector_var",
                         choices = names(selected_data()))
  })

  observe({  # The drop-down menu depends on data set.
    updateSelectizeInput(session, "case_var",
                         choices = names(selected_data()))
  })


  observe({  # The drop-down menu depends on data set.
    updateSelectizeInput(session, "start_of_exposure",
                         choices = names(selected_data()))
  })


  observe({  # The drop-down menu depends on data set.
    updateSelectizeInput(session, "end_of_exposure",
                         choices = names(selected_data()))
  })


  observe({  # The drop-down menu depends on data set.
    updateSelectizeInput(session, "symptom_onset",
                         choices = names(selected_data()))
  })

  observe({  # The drop-down menu depends on data set.
    updateSelectizeInput(session, "last_negative",
                         choices = names(selected_data()))
  })


  observe({  # The drop-down menu depends on data set.
    updateSelectizeInput(session, "first_positive",
                         choices = names(selected_data()))
  })


  nodecol <- reactive({
    input$nodecol
  })

  # For figure: should symptoms and last neg. -  first pos. test be plotted?
  show_symptoms <- reactive({input$show_symptoms})
  show_testwindow <- reactive({ input$show_testwindow })


  ##### Subset based on subset choices. #####

  # Subset of data (based on selection options on the left)
  dat_for_tab <- reactive({
  # if(input$select_all == TRUE){
    mydat() %>%
        mutate(row_nr = row_number()) %>% relocate(row_nr)# %>%#} #else {
       #   return(mydat()
              #   arrange(.[[input$sort_by]]) #%>%
        #           filter(.[[colName()]] %in% categories()) %>%
         #          filter(.[[colName2()]] <= input$range[2] &
        #                    .[[colName2()]] >= input$range[1]) %>%
        #           filter(date_report >= input$date_range[1]) %>%
        #           filter(date_report <= input$date_range[2]) %>%

           #        mutate(row_nr = row_number()) %>% relocate(row_nr)
         # )

          # .[[]] corrects for the fact that colName is a string.
      #  }


  })

  ##### Create data table. #####
  output$table <- renderDataTable({
    as.data.frame( dat_for_tab() ) %>%
      #  filter( (id %in% selected_nodes()) |(infector %in% selected_nodes() )  ) %>%

      datatable(
        options = list(scrollX = TRUE)) %>%
      formatStyle(1:ncol(dat_for_tab()), lineHeight='60%')
    # Use datatable() to make sure dates are shown in correct format
  })


  # Network plot
#  dat_network <- reactive({
#    prepare_network(dat_for_tab())
#  })
  dat_network <- reactive({
    prepare_network_new(dat_for_tab(), input$case_var, input$infector_var)
  })

  output$network <- renderVisNetwork({
    vis_epicontacts(dat_network(), node_color = input$nodecol) %>%
      visOptions(highlightNearest=TRUE,
                 nodesIdSelection = TRUE) %>%
      visInteraction(multiselect = TRUE) %>%
      visEvents(select = "function(data) {
                Shiny.onInputChange('current_nodes_selection', data.nodes);
                Shiny.onInputChange('current_edges_selection', data.edges);
                ;}")


  })

  # Node selection to subset data
  selected_nodes <- reactive({
    input$current_nodes_selection
  })

  # Table selected nodes
  output$table_selected_nodes <- renderDataTable({
    as.data.frame( dat_for_tab() ) %>%
      filter( (Case_ID %in% selected_nodes()) |(infector %in% selected_nodes() )  ) %>%

      datatable(
        options = list(scrollX = TRUE)) %>%
      formatStyle(1:ncol(dat_for_tab()), lineHeight='60%')
    # Use datatable() to make sure dates are shown in correct format
  })




  ############### Timeline #########
  output$timeline <- renderPlotly({

    colors <- c("exposure window" = "blue", "symptom onset" = "orange",
                "last neg. to first pos." = "purple", "reported" = "green",
                "ID" = "black")
    shapes <- c(95, 43)

    mydat <- as.data.frame( dat_for_tab() ) %>%
      filter( (.[[input$case_var]] %in% selected_nodes()) |(.[[input$infector_var]] %in% selected_nodes() )  ) %>%
      mutate(case_var = .[[input$case_var]],
             start_of_exposure = .[[input$start_of_exposure]],
             end_of_exposure = .[[input$end_of_exposure]],
             symptom_onset = .[[input$symptom_onset]],
             last_negative = .[[input$last_negative]],
             first_positive = .[[input$first_positive]]
             ) %>%
      mutate(new_row_nr = row_number(), xloc = min(start_of_exposure, na.rm = TRUE))

    p <- ggplot(data = mydat
    #
    #   # Data selected nodes .[[colName()]]
# %>%
               # mutate(new_row_nr = 1:length(id)),

  #    dat_selected_nodes() %>% as.data.frame() #%>%
  #    mutate(new_row_nr = 1:nrow()),

      ) + geom_rect(aes(y = new_row_nr, xmin=start_of_exposure,
                                         xmax=
                                         end_of_exposure,
                           ymin = new_row_nr-0.5, ymax=new_row_nr+0.5),
                       fill="blue", alpha=.25) +
      geom_rect(aes(y = new_row_nr, xmin=last_negative,
                      xmax=
                        first_positive,
                      ymin = new_row_nr-0.5, ymax=new_row_nr+0.5),
                  fill="purple", alpha=.25) +

      # # Exposure
       geom_text(aes(x=start_of_exposure, y=new_row_nr,
                    color="exposure window"), size=4, label = "E0") +
       geom_text(aes(x=end_of_exposure, y=new_row_nr,
                     color="exposure window"), size=4, label = "E1")

      # Symptom onset
      if(show_symptoms() == TRUE){
      p <- p +
       geom_point(aes(x=symptom_onset, y=new_row_nr, color="symptom onset"), size=2)
      }

      if(show_testwindow() == TRUE){
      p <- p +
      # # Last negative test (P0)
      geom_text(aes(x=last_negative, y=new_row_nr,
                    color="last neg. to first pos."), size=4, label = "P0") +
      # First positive test (P1)
      geom_text(aes(x=first_positive, y=new_row_nr,
                    color="last neg. to first pos."), size=4, label = "P1")
      }
#        geom_text(aes(x=first_positive, y=new_row_nr, color="tested positive"),
#                size=2,
#                label = "L1")

      p <- p +

      geom_text(aes(x = xloc, y=new_row_nr+0.5, label = case_var,
                    color="ID"), size=2) +

      scale_x_date("Calender time"#,
                                           # limits = input$date_range
                                           ) +
      scale_y_discrete(paste("Cases (one per row)")) + labs(color = "") +
      theme_bw() +
      scale_color_manual(values = colors) +
      theme(axis.text.y = element_blank(),
            axis.ticks.y= element_blank(),
            axis.text.x=element_text(color="black"),
            panel.grid.major = element_blank()#,
        #    panel.grid = element_blank()#,
                                                             #   panel.grid.minor = element_blank()
            ) #panel.grid.major = element_line(colour = "darkgrey", linetype = 1))+


    ggplotly(p, height = # https://www.r-bloggers.com/2017/06/get-the-best-from-ggplotly/
               # https://plotly.com/ggplot2/

      400
      #          35*nrow(
      #
      # # Subset data based on selected nodes
      # as.data.frame( dat_for_tab() ) %>%
      #   filter( (id %in% selected_nodes()) |(infector %in% selected_nodes() )  )
      #
      #                           )

      ) %>%
      layout(
        showlegend = T,
        legend = list(x = 0, y = 1.15, orientation = 'h'),
        xaxis = list(
          color = "transparent"
        ),
        yaxis = list(
          color = "transparent"
        )

      )

    })

  ###########################


  ##### Data subsets and other files that should be updated in the app.
  #   These are inputs for the tabel et cetera above.

  # Data selected nodes
  dat_plot_nodes <- reactive({

      mydat()  %>%
        filter( (id %in% selected_nodes())
                |(infector %in% selected_nodes() )  ) %>%
        mutate(row_nr = row_number()) %>% relocate(row_nr)

      # .[[]] corrects for the fact that colName is a string
  })

  output$drawmap <- renderLeaflet({
    
    contacts <- mydat()%>%select(Case_ID, starts_with("ID_of_the_source"))%>%
      pivot_longer(cols = starts_with("ID_of_the_source"),
                   values_to = "from",
                   values_drop_na = TRUE)%>%
      rename(to = Case_ID)%>%
      select(3,1)
    
    address <- mydat()%>%select(Case_ID, lat, lon)
    
    n <- graph.data.frame(contacts, directed = TRUE, vertices = address) 
    network <-  get.data.frame(n, "both")
    
    ## get vertices (nodes) dataset
    vert <- network$vertices
    coordinates(vert) <- ~ lon + lat
    
    ## get edges dataset
    edges <- network$edges
    edges <- lapply(1:nrow(edges), function(i) {
      as(rbind(vert[vert$name == edges[i, "from"], ],
               vert[vert$name == edges[i, "to"], ]),
         "SpatialLines")
    }
    )
    
    for (i in seq_along(edges)) {
      edges[[i]] <- spChFIDs(edges[[i]], as.character(i))
    }
    
    edges <- do.call(rbind, edges) 
    leaflet() %>%
      addTiles() %>%
      addCircles(data = vert, radius = 8,color = "red", weight = 8,
                 label = vert$name,labelOptions = labelOptions(noHide = T,textOnly = T, textsize = "20px"))%>%
      leaflet.extras2::addArrowhead(data = edges, color="green",group="green",weight = 2,
                   options = leaflet.extras2::arrowheadOptions(yawn = 30,size = '18px',frequency = 'endonly',proportionalToTotal = T,fill = T))
    })

  
})


# Run app
shinyApp(ui, server)
