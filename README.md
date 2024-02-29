---
title: "Contact Tracing"
bibliography: references.bib
csl: ieee.csl
knit: |
  (function(input, ...) {
    rmarkdown::render(
      input,
      output_file =  'index.html',
      envir = globalenv()
    )
  })  
---

# I. Introduction

Contact tracing is an essential public health tool for controlling infectious disease outbreaks such as those caused by the COVID-19 virus[@1; @2]. Before May 2021, with wild-type and alpha variants of COVID-19[@3], Ho Chi Minh city (HCM)-- the largest city in the south of Vietnam, had a few outbreaks and successfully contained them in a short period. One of the factors contributing to the success in HCM was intensive contact tracing for quarantine and isolation.

Policies for isolation and quarantine rely on accurate knowledge of the duration after infection before the virus can be detected (latency time) and the duration after infection for these symptoms to appear (incubation time). Studies on the variation of these parameters are hampered by incomplete information, often based on data that were not primarily collected for scientific purposes.

In HCM, Public health staff contacted and traced up to the second generation of cases' contacts. The confirmed case report was recorded in a word file with very simple template and inconsistent contacts history.

With the spread of Delta variant from May, 2021[@3], the number of cases increased rapidly within a short period overwhelming the contact tracing work as the work on the word files took time. There were recommendations about digital forms that could improve the contact tracing process[@4], and WHO also developed digital tools[@5] in 2020 to support public health staff. However, the tools seemed to be complicated and was not used in HCM in 2021. Drawing from our experiences while working on confirmed case reports in HCM from May to July 2021, we have designed and proposed a prototype tool. This tool encompasses a straightforward digital questionnaire form implemented on the KoboToolbox platform[@6], aiding in the tracing of contacts and facilitating direct data analysis using the R language with the KoboconnectR package[@7]. And, an R Shiny application to visualize the network between cases.

# II. Objectives

In this study, our objectives are to develop a prototype tool that includes:

-   Designing a user-friendly digital questionnaire form aimed at assisting public health staff in efficiently collecting information for contact tracing. Additionally, this form facilitates direct data analysis by scientists utilized KoboconnectR package.

-   An R Shiny application to visualize the network of the cases with the data from the digital form above to support the policy makers have the decisions in time.

# III. Method

## 1. Design the questionnaire

In this propose, we will use KoboToolbox platform for developing the questionnaire. KoboToolbox is an open source platform for the collection, management, and visualization of data. It is designed for practitioners, offering an intuitive and accessible interface, making it easy to swiftly develop questionnaires. It can operate offline on any device, and notably, all its core functionalities are freely accessible for nonprofit organizations. As the foremost data collection tool in the nonprofit sector, it is the preferred choice for over 14,000 social impact organizations globally.

KoboToolbox is utilized in diverse sectors such as humanitarian action, global development, environmental protection, peacebuilding, human rights, public health institutes, research organizations, and educational facilities. Offering an intuitive user interface available in multiple languages, KoboToolbox ensures user owned data with complete control over data access. It facilitates the General Data Protection Regulation (GDPR) compliance through Free Data Processing Agreements (DPA) upon request. Further enhancing its appeal are custom features, secure standalone servers, and on-demand support, all aligned with high data security standards by design. As of November 2022, KoboToolbox has more than 700,000 users globally and collects over 20 million surveys a month.

We designed and developed the questionnaire follow the five key steps below:

Step 1: Identify the goals of the questionnaire

The questionnaire is designed to facilitate contact tracing efforts in anticipation of future outbreaks, with a specific focus on infectious diseases transmitted via the respiratory route. The questions should be easy to understand for the broad community with diverse background and age rank. The information collected from the questionnaire supposed to support the public health staff to shorten the time of contact tracing process, also to support the researchers to work directly with the data collected and estimate the characteristic parameters of the diseases: Incubation time, latency time which will support the decision of policy makers about the period of quarantine and isolation.

Step 2: Define the targeted respondents

The questionnaire would be used in the context of interviewing which means there will be interviewer and interviewee. The interviewer should be public health staff or anyone has been trained and responsible for tracing the contacts. The interviewees can be confirmed cases and their contacts. The target of respondents is diverse to all over community with different background, age, gender....

Step 3: Develop questions and choose question type

-   Based on the Guidance for tracing contacts of confirmed cases in the Regulations No. 5053/2020/QĐ-BYT issued by Ministry of Health (MoH), Vietnam on 03/12/2020[@8].

-   Based on the simple template which public health staff in HCM used in the period of May - July 2021

-   Add questions to get more information for estimating latency time, incubation time.

Step 4: Design question sequence and overall layout

At the time we developed this questionnaire, COVID-19 has been spreading in Vietnam for over two years. Following the MoH's guidelines, public health staff in HCM have a lot of experience tracing contacts of confirmed cases and their contacts. We closely collaborated with those who performed contact tracing during outbreaks to gather feedback and improve our approach.

Step 5: Test the questionnaire

**Challenges**: When we have the draft of the form we could not perform a pilot test as the outbreak was over.

**Opportunity**: At Oxford University Clinical Research Unit (OUCRU), we have set up a Community Advisory Board (CAB)[@9]. It is a group of interested individuals from the community, who are invited to meet with health professionals and researchers to contribute opinions, feedback and suggestions for public health research conducted by OUCRU. Representation on the CAB is 10-15 public people. The purposes of the board are: 1) To provide a platform linking researchers, health care workers and the wider community that enable effective and impactful health research; 2) Explore current perceptions and opinions of the community towards health research;

We met with 8 members of CAB and 1 public health staff from HCM Center for Disease Control (HCDC) for two and half hours. After gave the board an overview about the project include: objectives, context, challenges, we went through the questionnaire one by one to modify questions which are unclear. In the end of the meeting, we looked over the sequence and layout to make sure the flow of the questionnaire meets the understanding of both community and public health staff.

## 2. Utilize KoboconnectR package and develop R Shiny application

Most of statistical analysis are performed in R. To streamline the process of transferring data from KoboToolbox to R, several packages have been created. We opted for KoboconnectR as our tool of choice for extracting data from KoboToolbox projects/assets into R. This choice was made because, at the time, KoboconnectR stood out as the most comprehensive and well-developed package, eliminating the need to download individual spreadsheet files.

In another study, we were working on individual COVID-19 confirmed case report from HCM between May and July 2021. The main objective was to estimate the incubation time and latency time of Delta variant. One of crucial information for determining these times is the exposure window. To assist in choosing the exposure window, we made a simple R Shiny application that visualizes the contact network based on entered data and the individual exposure information. After building the questionnaire, we enhanced the app to make it more user-friendly. This app will help Policy Makers see when and where outbreaks are happening and how big they are, supporting them in making decisions to contain the outbreak.

# IV. Result - Tools

-   Questionnaire: The questionnaire form can be accessed via the [KoboToolbox](https://ee.kobotoolbox.org/x/BfIvw6ed) link. For additional information about the data dictionary and how to use the questionnaire, please refer to the wiki page. The tutorial for extracting and loading data from KoboToolbox into R is available in the "Export data from KoboToolbox tutorial" folder.

-   R Shiny application: The app is stored in the "Contact Network Visualization" folder. To run the app, start with prep.R, followed by ui.R, and finally run server.R. Open the app in a browser to observe the network on OpenStreetMap. The steps outlined in the app can be followed using the provided example data.

**Reference:**
