SOP （Spatial_Omic_Pathlogy）空间组学病理标准化工具
代码地址：https://github.com/YAOJ-bioin/SOP_Spatial_Omic_Pathlogy
SOP的常用含义为 Standard Operation Procedure 标准作业程序
R版本
空间组学数据（SM、ST）和HE病理图像的对准
文件名称：app_1_HE_image_assignment.R
运行方法：runApp('app_1_HE_image_assignment.R')示例： Step1: 运行对准工具。
Step2: 上传HE 病理图像，要求png格式。
Step3: 上传原始的空间组学坐标（raw_sp_coordinates），要求csv格式，示例如下：其中必须包含的3列包括：第一列为SPOT点名称，imagecol2, imagerow2 这两节为原始的空间组学坐标

Step4: 完成图像上传后，会显示前景和后景图像的原始状态，如下图所示。工具提供了四种变换，以供ST-omics坐标与HE图像进行调整和变换。
● 平移（上下左右、可以控制移动步值）
● 旋转（向左和向右旋转，可以控制旋转角度）
● 翻转（水平和垂直）
● 拉伸（水平和垂直拉伸变换，可以scale factor控制变换比例)

Step5: 完成对齐后可以点击'Download adjusted coordinates'下载对齐后的坐标信息（.csv）。其中imagerow_adj,和imagecol_adj为变换对准后新的坐标，将用于下一步套索。


依据HE病理图像或组学聚类结果进行套索注释
文件名称：app_2_HE_image_annotation.R
运行方法：runApp('app_2_HE_image_annotation.R')示例： Step1: 运行注释工具

Step2: 上传HE图像，要求png格式
Step3: 上传对准后的空间组学meta.data.csv, 示例格式可以如下。其中关键需要包含4列：
● X： cell or spot name
● imagecol_adj: 对准后的列坐标
● imagerow_adj:对准后的行坐标
● Bayes_8_cluster: 组学数据无监督聚类结果（作为参考）

Step4: 完成两个input文件的读入后，会自动生成对齐结果。
Step5: 套索操作，对套索区域进行名称，颜色的注释，确认区域后可以点击'Confirm Lasso Annotation'按钮，在下方就会生成一条套索记录，记录套索区域的名称、注释颜色、包含的SPOT点数量。

Step6: 完成所有套索后，可以点击'Download Annotated meta.data' 可以下载带有注释结果的csv文件。结果文件会新增两列，分别代表每个每个SPOT点（或cell）被套索注释为的名称（HE_annotation）以及颜色(HE_color)。

当前操作建议


核心需要：根据已知的HE_SM对齐结果对HE图像进行二次比较精确的注释
当前操作建议：
● 由于代码具有一定的局限性，需要根据实际使用情况进行进一步优化，当前需要拿到快速的HE注释结果最好的方案是根据给出的HE和SM对准图像结果，由病理科医生直接在HE图像上使用imageJ，或者PS进行直接精准注释，给出注释后的HE图像。
● 然后由YAOJ根据金标准的结果进行套索获取每个注释区域的表达值。
● 主要问题：R shiny运行负载较大，速度比较慢，操作不够流畅。
Python版本
● 总体功能和R版本是一致的，方案基于react和flask建立应用
● 后端功能已经基本完成
● 图片是foreground和background重叠在一起对齐之后的，foreground透明度可以调节。
● 前端是在canvas画布上根据图片像素绘制圆点，通过选择这些点模拟标注时选择的spot
● 当前问题：图片显示部分还有一些bug需要调整。
