#
# UoN scraper-specific variables.
#
# Copyright (C) 2013 Richard Mortier <mort@cantab.net>. All Rights Reserved.
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 2 as published by
# the Free Software Foundation
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
# more details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, write to the Free Software Foundation, Inc., 59 Temple
# Place - Suite 330, Boston, MA 02111-1307, USA.

self = {}

self.modules = {
  "G50PRO": "018563" ,
  "G50WEB": "018561" ,
  "G51APS": "016658" ,
  "G51CSA": "002235" ,
  "G51DBS": "016949" ,
  "G51FSE": "021236" ,
  "G51FUN": "007252" ,
  "G51IAI": "016973" ,
  "G51MCS": "010233" ,
  "G51OOP": "021233" ,
  "G51PRG": "012192" ,
  "G51REQ": "021185" ,
  "G51TUT": "019438" ,
  "G51UST": "017010" ,
  "G51WPS": "017011" ,
  "G52ADS": "007255" ,
  "G52AFP": "018180" ,
  "G52APR": "021311" ,
  "G52APT": "021245" ,
  "G52CCN": "002252" ,
  "G52CON": "002253" ,
  "G52CPP": "022258" ,
  "G52GRP": "008415" ,
  "G52GUI": "018177" ,
  "G52HCI": "018255" ,
  "G52IFR": "021216" ,
  "G52IMO": "021246" ,
  "G52MAL": "018194" ,
  "G52PAS": "021232" ,
  "G52SEM": "021243" ,
  "G52TUT": "019439" ,
  "G53ARS": "023421" ,
  "G53ASD": "010236" ,
  "G53BIO": "015709" ,
  "G53CCT": "021220" ,
  "G53CMP": "021224" ,
  "G53COM": "002268" ,
  "G53CWO": "023374" ,
  "G53DOC": "021231" ,
  "G53ELC": "010238" ,
  "G53FUZ": "023393" ,
  "G53GRA": "021221" ,
  "G53IDA": "002272" ,
  "G53IDE": "004962" ,
  "G53IDJ": "008416" ,
  "G53IDS": "008462" ,
  "G53IDY": "019309" ,
  "G53KRR": "018195" ,
  "G53NMD": "021217" ,
  "G53OPS": "002276" ,
  "G53ORO": "018252" ,
  "G53SEC": "018176" ,
  "G53SQM": "022254" ,
  "G54999": "022992" ,
  "G54ACC": "021237" ,
  "G54ADM": "021235" ,
  "G54ALG": "021249" ,
  "G54ARC": "021250" ,
  "G54CCS": "022256" ,
  "G54CON": "021816" ,
  "G54DIA": "021226" ,
  "G54DMT": "021183" ,
  "G54FOP": "018385" ,
  "G54FPP": "021251" ,
  "G54GRP": "021788" ,
  "G54IHC": "021190" ,
  "G54INT": "021787" ,
  "G54MDP": "021255" ,
  "G54MET": "021188" ,
  "G54MGA": "023468" ,
  "G54MGP": "021253" ,
  "G54MIA": "023470" ,
  "G54MIP": "021254" ,
  "G54MXR": "021189" ,
  "G54ORM": "021489" ,
  "G54PDC": "021257" ,
  "G54PLP": "020241" ,
  "G54PRG": "021227" ,
  "G54PRO": "019348" ,
  "G54RP2": "022041" ,
  "G54RPS": "020837" ,
  "G54SAI": "022270" ,
  "G54SIM": "021202" ,
  "G54SUM": "021817" ,
  "G54UBI": "019275" ,
  "G54URP": "020240" ,
  "G64ADS": "018384" ,
  "G64DBS": "012353" ,
  "G64DEC": "023529" ,
  "G64HCI": "022388" ,
  "G64ICP": "006637" ,
  "G64INC": "013184" ,
  "G64MIT": "006640" ,
  "G64OOS": "009759" ,
  "G64PIT": "013747" ,
  "G64PMI": "013746" ,
  "G64PRE": "018518" ,
  "G64SPM": "013183" ,
  "G64SWE": "009760" ,

  "G52IIP": "021218" ,
  "G53MLE": "021211" ,

  # "G53VIS": "" ,
  # "G54CPL": "" ,

  "G54DET": "023477" ,
  "G54VIS": "024449" ,

  # engineering
  "HG1FNC": "017984" ,
  "HG1M11": "005728" ,

  # business school
  "N11116": "021173" ,
  "N11120": "013601" ,
  "N11123": "007570" ,
  "N11126": "007571" ,
  "N11127": "007569" ,
  "N11129": "007578" ,
  "N11132": "014764" ,
  "N11135": "014763" ,
  "N11413": "003665" ,
  "N11440": "011729" ,
  "N11601": "016346" ,
  "N11602": "016344" ,
  "N11603": "016347" ,
  "N11604": "016345" ,
  "N12001": "015538" ,
  "N12118": "008347" ,
  "N12205": "003644" ,
  "N12402": "003673" ,
  "N12406": "013535" ,
  "N12415": "003682" ,
  "N12435": "007575" ,
  "N12612": "018041" ,
  "N12613": "018042" ,
  "N12614": "018043" ,
  "N12801": "020204" ,
  "N12814": "014469" ,
  "N13410": "003677" ,
  "N13418": "003684" ,
  "N13425": "005068" ,
  "N13426": "005069" ,
}

self.theme_codes = {
  "SE": "Software Engineering",
  "FCS": "Foundations of Computer Science",
  "OSA": "Operating Systems and Architecture",
  "P": "Programming",
  "NCC": "Net-Centric Computing",
  "AI": "Artificial Intelligence",
  "HCI": "Human-Computer Interaction",
  "MO": "Modelling and Optimisation",
  "GV": "Graphics and Vision",
}

self.themes = {  
  "G50ALG": "FCS",
  "G50PRO": "P",
  "G50WEB": "NCC",
  "G51APS": "FCS",
  "G51CSA": "OSA",
  "G51DBS": "SE",
  "G51FSE": "SE",
  "G51FUN": "P",
  "G51IAI": "AI",
  "G51MCS": "FCS",
  "G51OOP": "P",
  "G51PRG": "P",
  "G51REQ": "HCI",
  "G51UST": "OSA",
  "G51WPS": "NCC",
  "G52ADS": "FCS",
  "G52AFP": "P",
  "G52APR": "P",
  "G52APT": "AI",
  "G52CCN": "NCC",
  "G52CON": "OSA",
  "G52CPP": "P",
  "G52GRP": "SE",
  "G52GUI": "HCI",
  "G52HCI": "HCI",
  "G52IFR": "FCS",
  "G52IIP": "GV",
  "G52IMO": "MO",
  "G52MAL": "FCS",
  "G52PAS": "AI",
  "G52PRO": "HCI",
  "G52SEM": "SE",
  "G53AOP": "P",
  "G53ARS": "AI",
  "G53ASD": "MO",
  "G53BIO": "MO",
  "G53CCT": "HCI",
  "G53CLP": "MO",
  "G53CMP": "P",
  "G53COM": "FCS",
  "G53DOC": "GV",
  "G53DSM": "MO",
  "G53DVA": "FCS",
  "G53ELC": "NCC",
  "G53FUZ": "AI",
  "G53GRA": "GV",
  "G53HCI": "HCI",
  "G53KRR": "AI",
  "G53MLE": "AI",
  "G53NMD": "HCI",
  "G53OPS": "OSA",
  "G53ORO": "MO",
  "G53SEC": "NCC",
  "G53SQM": "SE",
  "G53VAI": "GV",
  "G54ACC": "NCC",
  "G54ADB": "SE",
  "G54ADM": "OSA",
  "G54ALG": "P",
  "G54ARC": "OSA",
  "G54ASB": "MO",
  "G54CCS": "NCC",
  "G54CGA": "GV",
  "G54CPL": "P",
  "G54DET": "HCI",
  "G54DIA": "AI",
  "G54DMT": "MO",
  "G54DTP": "FCS",
  "G54FOP": "FCS",
  "G54FPP": "FCS",
  "G54GAM": "HCI",
  "G54HPA": "AI",
  "G54IHC": "HCI",
  "G54INF": "FCS",
  "G54MDP": "P",
  "G54MET": "HCI",
  "G54MSP": "GV",
  "G54MXR": "HCI",
  "G54NSC": "MO",
  "G54ORM": "MO",
  "G54OSW": "AI",
  "G54PAL": "FCS",
  "G54PDC": "OSA",
  "G54PRG": "P",
  "G54SAI": "AI",
  "G54SIM": "MO",
  "G54TCN": "NCC",
  "G54UBI": "HCI",
  "G54UIP": "MO",
  "G54VAI": "GV",
  "G54VSA": "GV",
  "G64ADS": "FCS",
  "G64DBS": "SE",
  "G64FAI": "AI",
  "G64ICP": "P",
  "G64INC": "NCC",
  "G64MIT": "HCI",
  "G64OOS": "SE",
  "G64SPM": "SE",
  "G64SWE": "SE",

  ## unthemed modules?
  "G53CWO": "", # "and computing in the world at large (from scientific supercomputers, though PCs, tablets and phones to embedded computers, smart cards and RFID tags). Dependability of computer-based systems, and the nature and scope and management of risk in relation to such systems. Legal liability, data protection and intellectual property issues in computing. Social and cultural impacts of computing (e.g. through social networking), the portrayal of computers and computing in the popular media and in fiction and the ethical issues in computing. Sustainability and appropriate technology. The nature of professionalism, the role of professional bodies, and continuing professional development.
  "G53IDA": "", # "individual project on a topic in computer science with emphasis in Artificial Intelligence. Each student has a supervisor who is a member of the academic staff. The topic can be any area of the subject which is of mutual interest to both the student and supervisor but should involve a substantial software development component. Guidelines on word length of dissertation are flexible to accommodate differing types of project work  undertaken.<br><br>
  "G53IDE": "", # final dissertation allow students to choose an area of particular interest and study it in some detail. The nature of the work thus varies greatly depending upon the inclinations of the student. In general however these projects and their final dissertation represents the culmination of the students university career. It is difficult to describe the content of these projects and dissertation since each represents an individual piece of work. In general students spend Semesters 5 and 6 working on their projects, with the final dissertation normally to be handed in at the end of Semester 6. For UK students visiting European Institutions under the Erasmus exchange scheme, however, it is possible to work on their project abroad entirely in the sixth semester. They will also be expected to take one course to count 10 credits while abroad. It also means that they must take 70 credits worth of taught CS courses in semester 5. The dissertation should represent a deep and analytical piece of writing exploring key issues tackled during the work and can be submitted in English or the language of the visited. Students will work with academic members of staff on a one-to-one basis with regular weekly meetings to discuss progress and problems.
  "G53IDJ": "", # individual project on a topic in computer science.  Each student has a supervisor who is a member of the academic staff.  The topic can be any area of the subject which is of mutual interest to both the student and supervisor.  Topics can range form purely theoretical studies to practical work building a system for some third party, although  most projects aim to provide a balance between the theoretical and practical aspects of the subject.  Guidelines on word length of dissertation are flexible to accommodate differing types of project work (e.g. balance between theory and practice) undertaken.
  "G53IDS": "", # individual project on a topic in computer science.  Each student has a supervisor who is a member of the academic staff.  The topic can be any area of the subject which is of mutual interest to both the student and supervisor.  Topics can range from purely theoretical studies to practical work building a system for some third party, although most projects aim to provide a balance between the theoretical and practical aspects of the subject.  Guidelines on word length of dissertation are flexible to accommodate differing types of project work (e.g. balance between theory and practice) undertaken.<br><br>
  "G53IDY": "", # individual project on a topic in computer science with emphasis on software systems. Each student has a supervisor who is a member of the academic staff. The topic can be any area of the subject which is of mutual interest to both the student and supervisor but should involve a substantial software development component. Guidelines on word length of dissertation are flexible to accommodate differing types of project work  undertaken.<br><br>
  "G54AIT": "", # of empirical and/or library research. This research will be of some depth, and carried out under supervision of a member of academic staff. Where appropriate, projects may also be conducted in conjunction with an external organisation.
  "G54CON": "", # module should have completed a paper presentation (or poster accompanied by paper in proceedings) that has undergone peer review at a national or international conference.  The student should submit the paper, accompanied by a 500 word commentary that describes their motivation for the paper, the reception of the paper/poster at the conference and further steps that might be taken within their PhD as a result of the work presented.
  "G54MGA": "", # in Artificial Intelligence which is relevant to their programme of study and which builds on material studied. Students are responsible for forming a group of at least 2 students to work on this module together; if no group can be formed then module G54MIP must be taken instead. The topic must be agreed with the group, supervisor and Course Director. The project may be based on theoretical or empirical research or software development. The students must relate their project work to current research and/or professional practice. Agreed elements of the work must be conducted and coordinated as a group. In all cases suitable evaluation must be included, and relevant professional and ethical aspects considered. Collaboration with business, industry, and other outside bodies is encouraged. It is acceptable for a group project to collectively include both AI aspects to be undertaken by MSci Computer Science with AI students AND non-AI aspects to be undertaken by MSci Computer Science students.
  "G54MGP": "", # in Computer Science which is relevant to their programme of study and which builds on material studied. Students are responsible for forming a group of at least 2 students to work on this module together; if no group can be formed then module G54MIP must be taken instead. The topic must be agreed with the group, supervisor and Course Director. The project may be based on theoretical or empirical research or software development. The students must relate their project work to current research and/or professional practice. Agreed elements of the work must be conducted and coordinated as a group. In all cases suitable evaluation must be included, and relevant professional and ethical aspects considered. Collaboration with business, industry, and other outside bodies is encouraged.
  "G54MIA": "", # in Artificial Intelligence which is relevant to their programme of study and which builds on material studied. The topic must be agreed with the supervisor and Course Director. The project may be based on theoretical or empirical research or software development. The student must relate their project work to current research and/or professional practice. In all cases suitable evaluation must be included, and relevant professional and ethical aspects considered. Collaboration with business, industry, and other outside bodies is encouraged.
  "G54MIP": "", # in Computer Science which is relevant to their programme of study and which builds on material studied. The topic must be agreed with the supervisor and Course Director. The project may be based on theoretical or empirical research or software development. The student must relate their project work to current research and/or professional practice. In all cases suitable evaluation must be included, and relevant professional and ethical aspects considered. Collaboration with business, industry, and other outside bodies is encouraged.
  "G54PRO": "", # "of empirical and/or theoretical research in an appropriate strand of the degree. This research will be in-depth, and carried out under supervision of a member of academic staff. Where appropriate, projects may also be conducted in conjunction with an external organisation. Projects may or not involve a substantial software implementation.
  "G54RP2": "", # "programme of continuous specially adapted and co-designed training. This is developed from foundational Graduate School Researcher Development Programme courses. These sessions will build on previous the module. Learning Outcomes are explicitly mapped to the Researcher Development Framework for the module as a whole and for individual sessions of the continuous training.
  "G54RPS": "", # "of general and dedicated courses delivered by the graduate school.  Students will be required to attend a defined selection of graduate school courses that will provided them with a set of research and professional skills to support their PhD studies.
  "G54SUM": "", # "module should have attended the DTC summer school.  They should provide a 500-1000 word commentary, accompanied if needed by supporting material, to demonstrate that they have been an active participant in the DTC summer school.  Students will also need to be able to demonstrate that they have been present at all sessions of an individual summer school.  Examples of activities that may demonstrate active participation include leadership of or active participation in a workshop, data collection during a summer school event or participation in networking activities during or as a direct result of the summer school.  This module will normally be completed by 2nd or 3rd year students, but may be completed by students after their first attendance at the summer school in year 1.
  "G54URP": "", # "with staff of the DTC to develop a PhD research proposal during their first year in the centre.  This proposal will contain the following:    - Description of meetings, modules, seminars etc that motivated choice of PhD topics    - Formal record of at least 3 meetings with prospective supervisors    - Short literature review (approx 2000 words) describing current state of the art in selected area of study    - Proposed PhD aims and objectives    - Planned research activities for months 9-24 of registration described in detail    - Outline research activities for months 25-48 of registration
  "G64DEC": "", # "project are to enhance understanding in an area of relevance to the degree course. The student is expected to develop skills in research including, planning research activities, empirical investigation, literature review, critical reflection, evaluation, oral and written communication, individual learning and time management. The project may be undertaken on any topic which is relevant to Digital Economy and which is agreed by the relevant Course Director. Collaboration with business, industry, and other outside bodies is encouraged.
  "G64HCI": "", # "project are to enhance understanding in an area of relevance to the degree course. The student is expected to develop skills in research including, planning research activities, empirical investigation, literature review, critical reflection, evaluation, oral and written communication, individual learning and time management. The project may be undertaken on any topic which is relevant to Human-Computer Interaction and which is agreed by the relevant Course Director. Collaboration with business, industry, and other outside bodies is encouraged.
  "G64PIT": "", # "of practical      research. This research will be of some depth, and carried out under the      supervision of a member of academic staff. Where appropriate, projects may also      be conducted in conjunction with an external organisation.
  "G64PMI": "", # "of empirical, programming or library research in some depth under the supervision  of a member of academic staff. Where appropriate, projects may also be conducted in conjunction with an external organisation,
  "G64PRE": "", # "is to provide the opportunity to undertake independent research into a topic appropriate to Computer Science Technology Transfer. In undertaking the project, you should draw on and extend material presented in the course. The project has several aims, beyond reinforcing information and methodology presented in the taught modules.   You will gain experience by:</p>  <ul>  <LI>addressing the challenges involved in developing the commercial potential of a technological advance;</LI>  <LI>develop communication skills relevant to the process of transferring technology to a commercial environment both by</li>  <ul class="nest1">  <li>making presentations to non technical audiences</li>  <LI>developing a report appropriate for a set of potential investors</LI>  <LI>otherwise communicating ideas to customers through meetings in groups or as individuals</li>  </ul>  </ul>  <p>Projects will further enhance experience in group work. </p>    Supervisors will be appointed the collaborating Schools.  An interim report will be required by mid-march outlining the direction of the project, which will commence in June.</p>

  ## dead modules?
  "G54999": "", # "of the NCC",
  "G54IRS": "", # "Net-centric and HCI",
}

self.dates = {
  "2013/14": "000113", 
  "2012/13": "000112", 
  "2011/12": "000111", 
}

self.courses = {
  ## ignore part-time and ordinary for now: same key, different value

  ## undergraduate
  "G400": "000319", ## BSc (Hons) Computer Science
  "G404": "021006", ## MSci (Hons) Computer Science

  "G4G7": "016004", ## BSc (Hons) Computer Science with Artificial Intelligence
  "G4G1": "022660", ## MSci (Hons) Computer Science with Artificial Intelligence

  "G601": "021912", ## BSc (Hons) Software Engineering

  "GG41": "000334", ## BSc (Hons) Mathematics and Computer Science
  "GN42": "000337", ## BSc (Hons) Computer Science and Management Studies

  ## postgraduate    
  "G507": "000328", ## MSc Information Technology
  "G565": "012847", ## MSc Management of Information Technology
  
  "G403": "018617", ## MSc Advanced Computing Science
  "G900": "017726", ## MSc Scientific Computation
  
  "G440": "021339", ## MSc Human Computer Interaction
  "G402": "018566", ## MSc Computer Science and Entrepreneurship
}  

module.exports = self
