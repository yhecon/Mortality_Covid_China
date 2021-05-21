



### Readme

Replicated codes and data for **Short- and Medium-Term Impacts of Lockdowns** **on Non-COVID-19 Mortality in China** by Jin-Lei Qi et al. 

- Link to the paper: Under Review at *Nature Human Behaviour*, latest version will be updated soon

- Check [here](https://www.medrxiv.org/content/10.1101/2020.08.28.20183699v2) for an ealier version of this research.

  - *Note:* As we have several updates on this paper, the data and codes here are not consistent (in order) with the above earlier version.

  

- **Abstract**: Using death registries based on 300 million Chinese people and a difference-in-differences design, we find that China’s stringent lockdowns during the COVID-19 pandemic significantly reduced the non-COVID-19 mortality (by 4.6%). The health benefits persisted and became even greater after the lockdown rules were loosened (mortality reduced by 11.2%). Significant changes in people’s behaviors (e.g., wearing masks and practicing social distancing) and reductions in air pollution and traffic accidents could have driven the results. We estimate that 54,000 and 293,000 lives could have been saved from non-COVID-19 diseases/causes during the 50 days of lockdowns and the subsequent 115 days of the post-lockdown period (from April 8 to July 31, 2020) in the country. The results suggest that the rapid and strict virus countermeasures not only effectively controlled the pandemic in China but also brought about unintended and substantial public health benefits.



### Replication

- Software and Codes: STATA 16.0 or above is recommended in running the following do-files:

  - Figure 2-Figure 6: replication codes at ~/code/figure, fig2.do-fig6.do 
  - Table S1-TableS6: replication codes at ~/code/S_table, tableS1.do-tableS6
  - Extended Data Figures: replication codes at ~/code/ex_figure, ex1.do-ex7.do

  

- Data: all the data to replicate the results will be posted upon publication. 
  - main.dta: workfile to generate the baseline results
    - Figure 2, Figure 3, Figure 4, and Figure 6; 
    - Table S1, Table S2, Table S3, Table S5;
    - Extended Data Figures: ex_Figure2, ex_Figure3, ex_Figure4, ex_Figure5
  - case_data/covid.dta: city/prefectural level COVID status in China
    - Extended Data Figures: ex_Figure1
  - psm/nnm_indicator.dta
    - Extended Data Figures: ex_Figure4
  - hete/hetero.dta
    - Figure 5;
    - Table S4, Table S6;
    - Extended Data Figures: ex_Figure6
  - age/age.dta
    - Extended Data Figures: ex_Figure7

### **Acknowledgments**

In doing this project, we thank all the staff who work in the primary health facilities, hospitals, and Center for Disease Control and Prevention for death reporting at county/district, city, province, and national levels. We also thank Yun Qiu for sharing the community lockdown data with us, Wei Wang and Yaxuan Liu for providing excellent research assistance. 



- Last update: 21st May 2021