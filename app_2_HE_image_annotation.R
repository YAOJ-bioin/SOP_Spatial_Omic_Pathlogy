library(shiny)
library(ggplot2)
library(plotly)
library(shinyjs)
library(colourpicker)
library(png)

# Define UI
ui <- fluidPage(
  useShinyjs(),  # for enabling/disabling UI elements
  titlePanel("HE Image Annotation Tool"),
  sidebarLayout(
    sidebarPanel(
      fileInput("he_image", "Upload HE Image (.png)", accept = c("image/png")),
      fileInput("meta_data", "Upload meta.data (.csv)", accept = c(".csv")),
      
      wellPanel(
        textInput("region_name", "Annotation Name"),
        colourInput("region_color", "Annotation Color", value = "red"),
        actionButton("confirm_lasso", "Confirm Lasso Annotation")
      ),
      
      downloadButton("download_annotated_data", "Download Annotated meta.data")
    ),
    mainPanel(
      plotlyOutput("image_plot",width = "100%",height = "600px"),
      
      tableOutput("annotations_table")
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  rv <- reactiveValues(
    he_image = NULL,
    meta_data = NULL,
    lasso_data = NULL,
    annotations = data.frame(Region = character(), Color = character(), Points = integer(), stringsAsFactors = FALSE)
  )
  
  observeEvent(input$he_image, {
    req(input$he_image)
    rv$he_image <- readPNG(input$he_image$datapath)
  })
  
  observeEvent(input$meta_data, {
    req(input$meta_data)
    rv$meta_data <- read.csv(input$meta_data$datapath)
    rv$meta_data$HE_annotation <- NA
    rv$meta_data$HE_color <- NA
  })
  
  output$image_plot <- renderPlotly({
    req(rv$he_image, rv$meta_data)
    
    # Define colors for Bayes_8_cluster
    colors <- c("#4490cb", "#48ff00", "#ff0051", "#ffe100", "#ff8800", "#00fff2", "#ffae00", "#d0ff00", "#00ffae")
    
    gg <- ggplot() +
      annotation_raster(rv$he_image, xmin = 0, xmax = ncol(rv$he_image), ymin = 0, ymax = nrow(rv$he_image)) +
      geom_point(data = rv$meta_data, aes(x = imagecol_adj, y = imagerow_adj, color = as.factor(Bayes_8_cluster)), size=0.2, alpha = 0.3) +
      scale_color_manual(values = colors) +
      coord_fixed() +
      theme_void()
    
    ggplotly(gg, source = "A") %>%
      layout(dragmode = "lasso") %>%
      event_register("plotly_selected")
  })
  
  observeEvent(input$confirm_lasso, {
    req(rv$lasso_data, input$region_name, input$region_color)
    
    selected_points <- rv$lasso_data
    selected_points$HE_annotation <- input$region_name
    selected_points$HE_color <- input$region_color
    
    rv$annotations <- rbind(rv$annotations, data.frame(
      Region = input$region_name, 
      Color = input$region_color, 
      Points = nrow(selected_points), 
      stringsAsFactors = FALSE
    ))
    
    # Update meta.data with annotation
    rv$meta_data$HE_annotation[rv$meta_data$X %in% selected_points$X] <- input$region_name
    rv$meta_data$HE_color[rv$meta_data$X %in% selected_points$X] <- input$region_color
    
    # Reset lasso data
    rv$lasso_data <- NULL
    shinyjs::reset("region_name")
    shinyjs::reset("region_color")
  })
  
  observeEvent(event_data("plotly_selected", source = "A"), {
    lasso <- event_data("plotly_selected", source = "A")
    
    if (!is.null(lasso) && nrow(lasso) > 0) {
      rv$lasso_data <- rv$meta_data[lasso$pointNumber + 1, ]
    }
  })
  
  output$annotations_table <- renderTable({
    req(rv$annotations)
    rv$annotations
  })
  
  output$download_annotated_data <- downloadHandler(
    filename = function() {
      paste("annotated_meta_data", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(rv$meta_data, file, row.names = FALSE)
    }
  )
}

shinyApp(ui = ui, server = server)
