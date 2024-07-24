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

<p align="justify">
Contact tracing is an essential public health tool for controlling infectious disease outbreaks such as those caused by the SARS-CoV-2 virus[@1; @2]. Before May 2021, with wild-type and alpha variants of SARS-CoV-2[@3], Ho Chi Minh city (HCMC)-- the largest city in the south of Vietnam, had a few small outbreaks and successfully contained them in a short period. One of the factors contributing to the success in HCMC was intensive contact tracing for quarantine and isolation.
</p>

<p align="justify">
Policies for isolation and quarantine rely on accurate knowledge of the duration from infection until the virus can be detected (latency time) and the duration from infection to symptoms onset (incubation time). Studies on the variation of these parameters are hampered by incomplete information, often based on data that were not primarily collected for scientific purposes.
</p>

<p align="justify">
In HCMC, Public health staff traced the contacts of infected individuals. For each contact, a case report was made, based on a very simple template.
</p>

<p align="justify">
With the spread of Delta variant from May, 2021[@3], the number of cases increased rapidly, quickly overwhelming the contact tracing work. Recommendations had been published about digital forms that could improve the contact tracing process[@4], and WHO also developed digital tools[@5] in 2020 to support public health staff. However, the tools seemed to be complicated and were not used in HCMC in 2021. Drawing from our experiences while working on confirmed case reports in HCM from May to July 2021, we have designed and proposed a prototype tool. This tool encompasses a straightforward digital questionnaire form implemented on the <a href="https://www.kobotoolbox.org/" title="Title"> KoboToolbox</a> platform[@6], aiding in the tracing of contacts and facilitating direct data analysis using the R language with the <a href="https://asitav-sen.github.io/KoboconnectR/" title="Title"> KoboconnectR</a> package[@7]. Moreover, we developed an R Shiny application to visualize the contact network between cases.
</p>

# II. Objectives

In this study, our objective was to develop a prototype tool that includes:

-   <p align="justify">Designing a user-friendly digital questionnaire form aimed at assisting public health staff in efficiently collecting information for contact tracing. Additionally, this form facilitates direct data import utilizing the KoboconnectR package.</p>

-   <p align="justify">An R Shiny application to visualize the contact network of the cases based on the data from the digital form above to support the policy makers in having the decisions in time.</p>

# III. Method

## 1. Design of the questionnaire

<p align="justify">
We used the KoboToolbox platform for developing the questionnaire. KoboToolbox is an open source platform for the collection, management, and visualization of data. It is designed for practitioners, offering an intuitive and accessible interface, making it easy to swiftly develop questionnaires. It can operate offline on any device, and notably, all its core functionalities are freely accessible for nonprofit organizations. As the foremost data collection tool in the nonprofit sector, it is the preferred choice for over 14,000 social impact organizations globally.
</p>

<p align="justify">
KoboToolbox is utilized in diverse sectors such as humanitarian action, global development, environmental protection, peacebuilding, human rights, public health institutes, research organizations, and educational facilities. Offering an intuitive user interface available in multiple languages, KoboToolbox ensures user owned data with complete control over data access. It facilitates the General Data Protection Regulation (GDPR) compliance through Free Data Processing Agreements (DPA) upon request. Further enhancing its appeal are custom features, secure standalone servers, and on-demand support, all aligned with high data security standards by design. As of November 2022, KoboToolbox has more than 700,000 users globally and collects over 20 million surveys a month.
</p>

We designed and developed the questionnaire following the five key steps below:

Step 1: Identify the goals of the questionnaire

<p align="justify">
The questionnaire is designed to facilitate contact tracing efforts in anticipation of future outbreaks, with a specific focus on infectious diseases transmitted via the respiratory route. The questions should be easy to understand for the broad community with diverse background and age rank. The information collected from the questionnaire is supposed to support the public health staff to shorten the time of contact tracing process, and to support the researchers to work directly with the data collected to estimate the characteristic parameters of the infection and disease process. These parameters are the incubation time and the latency time, which will support the decision of policy makers about the duration of quarantine and isolation.
</p>

Step 2: Define the targeted respondents

<p align="justify">
The questionnaire would be used in the context of interviewing which means there will be interviewer and interviewee. The interviewer should be public health staff or anyone who has been trained and responsible for tracing the contacts. The interviewees can be confirmed cases and their contacts. The target of respondents is diverse to all over community with different background, age, gender....
</p>

Step 3: Develop questions and choose question type

-   <p align="justify">Based on the Guidance for tracing contacts of confirmed cases in the Regulations No. 5053/2020/QĐ-BYT issued by Ministry of Health (MoH), Vietnam on 03/12/2020[@8].</p>

-   <p align="justify">Based on the simple template which public health staff in HCM used in the period of May - July 2021.</p>

-   <p align="justify">Add questions to get more information for estimating latency time and incubation time.</p>

Step 4: Design question sequence and overall layout

<p align="justify">
At the time we developed this questionnaire, there had been SARS-CoV-2 outbreaks in Vietnam for over two years. Following the MoH's guidelines, public health staff in HCM had a lot of experience in tracing contacts of confirmed cases and their contacts. We closely collaborated with those who performed contact tracing during outbreaks to gather feedback and improve our approach.
</p>

Step 5: Test the questionnaire

**Challenges**: <p align="justify">When we had the draft of the form we could not perform a pilot test as the outbreak was over.</p>

**Opportunity**: <p align="justify">At the Oxford University Clinical Research Unit (OUCRU), we have set up a Community Advisory Board (CAB)[@9]. It is a group of interested individuals from the community, who are invited to meet with health professionals and researchers to contribute opinions, feedback and suggestions for public health research conducted at OUCRU. The CAB consists of 10-15 people from the community. The purposes of the board are: 1) To provide a platform linking researchers, health care workers and the wider community that enable effective and impactful health research; 2) Explore current perceptions and opinions of the community towards health research.</p>

<p align="justify">
We met with 8 members of the CAB and 1 public health staff from the HCM Center for Disease Control (HCDC) for two and half hours. After giving the board an overview about the project including objectives, context and challenges, we went through the questionnaire one by one to modify questions which were unclear. At the end of the meeting, we looked over the sequence and layout to make sure the flow of the questionnaire met the understanding of both community and public health staff.
</p>

<p align="justify">
To streamline the process of transferring data from KoboToolbox to R, we used the KoboconnectR package. This choice was made because it stood out as the most comprehensive and well-developed package, eliminating the need to download individual spreadsheet files.
</p>

## 2. Develop R Shiny application

<p align="justify">
Besides, we wanted to estimate the latency time distribution of the Delta variant based individual case reports from HCMC prepared between May and July 2021. Crucial information for determining the latency time is the exposure window. To assist in choosing the exposure window, we made a simple R Shiny application that visualizes the contact network based on entered data and the individual exposure information. After building the questionnaire, we enhanced the app to make it more user-friendly. This app will help Policy Makers in detecting when and where outbreaks are happening and how big they are, supporting them in making decisions to contain the outbreak.
</p>

# IV. Result - Tools

-   <p align="justify">Questionnaire: The questionnaire form can be accessed via the <a href="https://ee.kobotoolbox.org/x/BfIvw6ed" title="Title"> KoboToolbox</a> link. The <a href="https://github.com/manhnguy/Contact-Tracing-for-Respiratory-Transmitted-Diseases/blob/main/questionnaire_built_form.xlsx" title="Title"> XLS built form</a> is also available to create your own project. For additional information about the data dictionary and how to use the questionnaire, please refer to the <a href="https://github.com/manhnguy/Contact-Tracing-for-Respiratory-Transmitted-Diseases/wiki" title="Title"> Wiki page</a>. The tutorial for extracting and loading data from KoboToolbox into R is available in the <a href="https://github.com/manhnguy/Contact-Tracing-for-Respiratory-Transmitted-Diseases/tree/main/Export%20data%20from%20KoboToolbox%20tutorial" title="Title"> Export data from KoboToolbox tutorial</a> folder.</p>

-   <p align="justify">R Shiny application: The app is stored in the <a href="https://github.com/manhnguy/Contact-Tracing-for-Respiratory-Transmitted-Diseases/tree/main/Contact%20Network%20Visualization%20-%20R%20Shiny%20Application" title="Title"> Contact Network Visualization</a> folder. To run the app, start with running prep.R, followed by ui.R, and finally server.R. Open the app in a browser to observe the network on OpenStreetMap. The steps outlined in the app can be followed using the provided example data.</p>

**Reference:**
