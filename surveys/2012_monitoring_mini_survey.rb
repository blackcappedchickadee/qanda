survey "2012 Monitoring and Evaluation Questionnaire - Mini Survey" do
  section "Satisfaction" do
    
    label "<br/>"
    
    q_1 "Do you have any thoughts for the questionnaire process you just completed?", :custom_class => 'sat_q1', :data_export_identifier => "sat_quest_thoughts"
    a_1 :text
    
    q_2 "Do you have any recommendations to improve this process?", :custom_class => 'sat_q2', :data_export_identifier => "sat_quest_process"
    a_2 :text
    
    label "<br/>Thank you for your feedback!<br/><br/>"
    
  end
end