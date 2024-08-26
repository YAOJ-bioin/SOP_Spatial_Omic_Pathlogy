**SOP** （Spatial_Omic_Pathlogy）空间组学病理标准化工具
代码地址：https://github.com/YAOJ-bioin/SOP_Spatial_Omic_Pathlogy
_SOP的常用含义为 Standard Operation Procedure 标准作业程序_
# R版本
## 空间组学数据（SM、ST）和HE病理图像的对准
**文件名称：**app_1_HE_image_assignment.R
**运行方法：**`runApp('app_1_HE_image_assignment.R')`**示例：** Step1: 运行对准工具。
Step2: 上传HE 病理图像，要求png格式。
Step3: 上传原始的空间组学坐标（raw_sp_coordinates），要求csv格式，示例如下：其中必须包含的3列包括：第一列为SPOT点名称，imagecol2, imagerow2 这两节为原始的空间组学坐标
![](https://cdn.nlark.com/yuque/0/2024/png/1783723/1724634910834-56aa052f-50b4-4556-81e4-b7381729f07b.png#averageHue=%23f3f1ef&clientId=u8f9f7d93-e3ed-4&from=paste&id=u54f8417f&originHeight=512&originWidth=960&originalType=url&ratio=1.25&rotation=0&showTitle=false&status=done&style=none&taskId=uc8f6764b-d636-4eaf-a14c-f6d7b4fd2d5&title=)
Step4: 完成图像上传后，会显示前景和后景图像的原始状态，如下图所示。工具提供了四种变换，以供ST-omics坐标与HE图像进行调整和变换。

- **平移**（上下左右、可以控制移动步值）
- **旋转**（向左和向右旋转，可以控制旋转角度）
- **翻转**（水平和垂直）
- **拉伸**（水平和垂直拉伸变换，可以scale factor控制变换比例)

![](https://cdn.nlark.com/yuque/0/2024/png/1783723/1724634910820-555dd40d-b40c-43cf-90e4-d1154d331aaa.png#averageHue=%23d3baa4&clientId=u8f9f7d93-e3ed-4&from=paste&id=udf9646e5&originHeight=902&originWidth=878&originalType=url&ratio=1.25&rotation=0&showTitle=false&status=done&style=none&taskId=u4cd1804c-5e79-493e-8b23-c4b472c79e9&title=)
Step5: 完成对齐后可以点击'Download adjusted coordinates'下载对齐后的坐标信息（.csv）。其中imagerow_adj,和imagecol_adj为变换对准后新的坐标，将用于下一步套索。
![](https://cdn.nlark.com/yuque/0/2024/png/1783723/1724634910964-063f2261-8b44-4976-ab28-98a26627d46b.png#averageHue=%23d8c1ac&clientId=u8f9f7d93-e3ed-4&from=paste&id=u804799b3&originHeight=902&originWidth=894&originalType=url&ratio=1.25&rotation=0&showTitle=false&status=done&style=none&taskId=ue079bb30-0ffe-411c-892a-e9c33c584fe&title=)
![](https://cdn.nlark.com/yuque/0/2024/png/1783723/1724634910860-8f7cfbfd-1ef9-4c6d-abc3-d56e458a2369.png#averageHue=%23f2efec&clientId=u8f9f7d93-e3ed-4&from=paste&id=uec802bff&originHeight=361&originWidth=1266&originalType=url&ratio=1.25&rotation=0&showTitle=false&status=done&style=none&taskId=u6ea4aa80-7d87-40fe-805a-95e5fe4865b&title=)
## 依据HE病理图像或组学聚类结果进行套索注释
**文件名称：**app_2_HE_image_annotation.R
**运行方法：**`runApp('app_2_HE_image_annotation.R')`**示例：** Step1: 运行注释工具
![](https://cdn.nlark.com/yuque/0/2024/png/1783723/1724634911018-a69dc47e-a94e-433f-b11a-d5320003d702.png#averageHue=%23fbf4f3&clientId=u8f9f7d93-e3ed-4&from=paste&id=u46ac1172&originHeight=962&originWidth=1112&originalType=url&ratio=1.25&rotation=0&showTitle=false&status=done&style=none&taskId=u91fe4c94-499c-4dd3-8350-2e15a4919b4&title=)
Step2: 上传HE图像，要求png格式
Step3: 上传对准后的空间组学meta.data.csv, 示例格式可以如下。其中关键需要包含4列：

- X： cell or spot name
- imagecol_adj: 对准后的列坐标
- imagerow_adj:对准后的行坐标
- Bayes_8_cluster: 组学数据无监督聚类结果（作为参考）

![](https://cdn.nlark.com/yuque/0/2024/png/1783723/1724634911410-658c74fc-eaaa-4df6-ba69-b85cfc55ee8f.png#averageHue=%23dbd8d0&clientId=u8f9f7d93-e3ed-4&from=paste&id=u782cf866&originHeight=425&originWidth=948&originalType=url&ratio=1.25&rotation=0&showTitle=false&status=done&style=none&taskId=ud4bd26aa-f98f-4a1c-9368-340c998cf05&title=)
Step4: 完成两个input文件的读入后，会自动生成对齐结果。
Step5: 套索操作，对套索区域进行名称，颜色的注释，确认区域后可以点击**'Confirm Lasso Annotation'**按钮，在下方就会生成一条套索记录，记录套索区域的名称、注释颜色、包含的SPOT点数量。
![](https://cdn.nlark.com/yuque/0/2024/png/1783723/1724634911495-92e90582-8292-4521-9c84-649080dfc2bd.png#averageHue=%23f8f2ee&clientId=u8f9f7d93-e3ed-4&from=paste&id=u05c94d9b&originHeight=925&originWidth=1905&originalType=url&ratio=1.25&rotation=0&showTitle=false&status=done&style=none&taskId=uabfabd99-b719-4873-8bb2-dfede1b73d9&title=)
Step6: 完成所有套索后，可以点击**'Download Annotated meta.data' **可以下载带有注释结果的csv文件。结果文件会新增两列，分别代表每个每个SPOT点（或cell）被套索注释为的**名称（HE_annotation）**以及**颜色(HE_color)**。
![](https://cdn.nlark.com/yuque/0/2024/png/1783723/1724634911724-e988a28f-e943-489f-acce-51e82d1e7468.png#averageHue=%23f6f0ed&clientId=u8f9f7d93-e3ed-4&from=paste&id=u6d50818f&originHeight=361&originWidth=963&originalType=url&ratio=1.25&rotation=0&showTitle=false&status=done&style=none&taskId=u83b46050-78c2-42b3-b64a-472c4419015&title=)
## 当前操作建议
![](https://cdn.nlark.com/yuque/0/2024/png/1783723/1724634911854-0fd9e9b1-3065-44fc-972c-7cb30d540fdf.png#averageHue=%23bbe29b&clientId=u8f9f7d93-e3ed-4&from=paste&id=ub2997ca0&originHeight=892&originWidth=1309&originalType=url&ratio=1.25&rotation=0&showTitle=false&status=done&style=none&taskId=u92ddc889-f607-4df9-99fc-4626b20446f&title=)
![](https://cdn.nlark.com/yuque/0/2024/png/1783723/1724634912076-14e0709d-0027-4414-9fd0-646e197c2098.png#averageHue=%23d0e5eb&clientId=u8f9f7d93-e3ed-4&from=paste&id=u7f98b03e&originHeight=664&originWidth=965&originalType=url&ratio=1.25&rotation=0&showTitle=false&status=done&style=none&taskId=ub9fa01ca-3e6c-4848-a141-a02b27c34ac&title=)
**核心需要：根据已知的HE_SM对齐结果对HE图像进行二次比较精确的注释**
当前操作建议：

- 由于代码具有一定的局限性，需要根据实际使用情况进行进一步优化，当前需要拿到快速的HE注释结果最好的方案是根据给出的HE和SM对准图像结果，由病理科医生直接在HE图像上使用imageJ，或者PS进行直接精准注释，给出注释后的HE图像。
- 然后由YAOJ根据金标准的结果进行套索获取每个注释区域的表达值。
- 主要问题：R shiny运行负载较大，速度比较慢，操作不够流畅。
# Python版本

- 总体功能和R版本是一致的，方案基于react和flask建立应用
- 后端功能已经基本完成
- 图片是foreground和background重叠在一起对齐之后的，foreground透明度可以调节。
- 前端是在canvas画布上根据图片像素绘制圆点，通过选择这些点模拟标注时选择的spot
- 当前问题：图片显示部分还有一些bug需要调整。

![](https://cdn.nlark.com/yuque/0/2024/png/1783723/1724634912299-d0dc3743-a9bd-4dd2-9787-5718b6a025b8.png#averageHue=%23fcfcfc&clientId=u8f9f7d93-e3ed-4&from=paste&id=u3a871904&originHeight=1696&originWidth=3360&originalType=url&ratio=1.25&rotation=0&showTitle=false&status=done&style=none&taskId=u46a42f14-92f1-4046-b810-0eaa48d359c&title=)
