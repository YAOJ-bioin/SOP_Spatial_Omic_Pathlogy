library(shiny)
library(ggplot2)
library(magick)
library(shinyFiles)
library(plotly)

# Define UI
ui <- fluidPage(
  titlePanel("HE Image Alignment Tool"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file1", "Upload HE Image", accept = c("image/png")),
      fileInput("file2", "Upload Coordinates Table", accept = c(".csv")),
      
      numericInput("translate_amount", "Translation Amount", value = 10, step = 1),# 数值输入控件，用于设置平移量
      actionButton("move_left", "Move Left"),
      actionButton("move_right", "Move Right"),
      actionButton("move_up", "Move Up"),
      actionButton("move_down", "Move Down"),
      
      numericInput("rotation_angle", "Rotation Angle", value = 1, step = 1),
      actionButton("rotate_left", "Rotate Left"),
      actionButton("rotate_right", "Rotate Right"),
      
      actionButton("vertical_flip", "Vertical Flip"),# 按钮，用于垂直翻转
      actionButton("horizontal_flip", "Horizontal Flip"),# 按钮，用于水平翻转
      
      numericInput("scale_factor", "Scale Factor", value = 1.1, step = 0.01),
      actionButton("vertical_scale", "Vertical Scale"), # 按钮，用于垂直缩放
      actionButton("horizontal_scale", "Horizontal Scale"),

      downloadButton("download_data", "Download Adjusted Coordinates")
    ),
    
    
    mainPanel(
      plotOutput("image_plot")
    
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  # Reactive values to store image and coordinates
  rv <- reactiveValues(
    img = NULL, # 原始图像
    img_raster = NULL, # 初始化 img_raster
    coords = NULL, # 原始坐标
    adj_coords = NULL, # 调整后的坐标
    rotation = 0, # 旋转角度
    scale = 1 # 缩放比例
  )
  
  # 监测数值输入控件的变化
  observe({
    rv$scale_factor <- input$scale_factor
    rv$translate_amount <- input$translate_amount
    rv$rotation_angle <- input$rotation_angle
  })
  
  
  # Upload HE image
  observeEvent(input$file1, {
    req(input$file1)
    rv$img <- image_read(input$file1$datapath) # 读取上传的图像
    rv$img_raster <- as.raster(rv$img) # 将图像转换为栅格格式
  })
  
  # Upload coordinates table
  observeEvent(input$file2, {
    req(input$file2) # 确保文件已上传
    rv$coords <- read.csv(input$file2$datapath) # 读取上传的坐标表
    rv$adj_coords <- rv$coords # 初始化调整后的坐标
  })
  
  # Apply transformations
  observeEvent(input$move_left, {
    req(rv$adj_coords) # 确保坐标已加载
    rv$adj_coords$imagecol2 <- rv$adj_coords$imagecol2 - input$translate_amount  # 向左平移
  })
  
  observeEvent(input$move_right, {
    req(rv$adj_coords)
    rv$adj_coords$imagecol2 <- rv$adj_coords$imagecol2 + input$translate_amount
  })
  
  observeEvent(input$move_up, {
    req(rv$adj_coords)
    rv$adj_coords$imagerow2 <- rv$adj_coords$imagerow2 - input$translate_amount
  })
  
  observeEvent(input$move_down, {
    req(rv$adj_coords)
    rv$adj_coords$imagerow2 <- rv$adj_coords$imagerow2 + input$translate_amount
  })
  
  observeEvent(input$rotate_left, {
    req(rv$adj_coords)
    # 计算坐标图中心
    center_x <- mean(rv$adj_coords$imagecol2)
    center_y <- mean(rv$adj_coords$imagerow2)
    # 更新旋转角度
    rv$rotation <- rv$rotation - input$rotation_angle
    # 将角度转换为弧度
    angle_rad <- rv$rotation * pi / 180
    # 旋转矩阵
    rotation_matrix <- matrix(c(cos(angle_rad), -sin(angle_rad), sin(angle_rad), cos(angle_rad)), nrow = 2)
    # 将坐标转换为矩阵
    coords <- as.matrix(rv$adj_coords[, c("imagecol2", "imagerow2")])
    # 将坐标平移到图中心
    coords_shifted <- sweep(coords, 2, c(center_x, center_y), FUN = "-")
    # 进行矩阵乘法实现旋转
    rotated_coords_shifted <- t(rotation_matrix %*% t(coords_shifted))
    # 将坐标平移回原位置
    rotated_coords <- sweep(rotated_coords_shifted, 2, c(center_x, center_y), FUN = "+")
    # 更新列坐标和行坐标 
    rv$adj_coords$imagecol2 <- rotated_coords[, 1]
    rv$adj_coords$imagerow2 <- rotated_coords[, 2]
  })
  
  observeEvent(input$rotate_right, {
    req(rv$adj_coords)
    # 计算坐标图中心
    center_x <- mean(rv$adj_coords$imagecol2)
    center_y <- mean(rv$adj_coords$imagerow2)
    # 更新旋转角度
    rv$rotation <- rv$rotation + input$rotation_angle
    # 将角度转换为弧度
    angle_rad <- rv$rotation * pi / 180
    # 旋转矩阵
    rotation_matrix <- matrix(c(cos(angle_rad), -sin(angle_rad), sin(angle_rad), cos(angle_rad)), nrow = 2)
    # 将坐标转换为矩阵
    coords <- as.matrix(rv$adj_coords[, c("imagecol2", "imagerow2")])
    # 将坐标平移到图中心
    coords_shifted <- sweep(coords, 2, c(center_x, center_y), FUN = "-")
    # 进行矩阵乘法实现旋转
    rotated_coords_shifted <- t(rotation_matrix %*% t(coords_shifted))
    # 将坐标平移回原位置
    rotated_coords <- sweep(rotated_coords_shifted, 2, c(center_x, center_y), FUN = "+")
    # 更新列坐标和行坐标
    rv$adj_coords$imagecol2 <- rotated_coords[, 1]
    rv$adj_coords$imagerow2 <- rotated_coords[, 2]
  })
  
  observeEvent(input$vertical_flip, {
    req(rv$adj_coords)
    image_mid_y <- nrow(rv$img_raster) / 2
    rv$adj_coords$imagerow2 <- image_mid_y - (rv$adj_coords$imagerow2 - image_mid_y)
  })
  
  observeEvent(input$horizontal_flip, {
    req(rv$adj_coords)
    image_mid_x <- ncol(rv$img_raster) / 2
    rv$adj_coords$imagecol2 <- image_mid_x - (rv$adj_coords$imagecol2 - image_mid_x)
  })
  
  observeEvent(input$vertical_scale, {
    req(rv$adj_coords)
    scale_factor <- input$scale_factor
    rv$adj_coords$imagerow2 <- rv$adj_coords$imagerow2 * scale_factor
  })
  
  observeEvent(input$horizontal_scale, {
    req(rv$adj_coords)
    scale_factor <- input$scale_factor
    rv$adj_coords$imagecol2 <- rv$adj_coords$imagecol2 * scale_factor
  })
  

  
  # Render image plot
  output$image_plot <- renderPlot({
    req(rv$img_raster, rv$adj_coords)
    ggplot() +
      annotation_raster(rv$img_raster, xmin = 0, xmax = ncol(rv$img_raster), ymin = 0, ymax = nrow(rv$img_raster)) +
      geom_point(data = rv$adj_coords, aes(x = imagecol2, y = imagerow2), color = "red", size = 0.5, alpha = 0.3) +
      coord_fixed() +
      theme_void()
  })
  
  # Download adjusted coordinates
  output$download_data <- downloadHandler(
    filename = function() {
      paste("adjusted_coordinates_",Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      req(rv$adj_coords)
      rv$adj_coords$imagerow_adj <- rv$adj_coords$imagerow2
      rv$adj_coords$imagecol_adj <- rv$adj_coords$imagecol2
      write.csv(rv$adj_coords, file, row.names = FALSE)
    }
  )
}

# Run the application
shinyApp(ui = ui, server = server)
