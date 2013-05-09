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
  "PR": "Programming",
  "NCC": "Net-Centric Computing",
  "AI": "Artificial Intelligence",
  "HCI": "Human-Computer Interaction",
  "MO": "Modelling and Optimisation",
  "PJ": "Projects",
}

self.themes = {  
  "G50ALG": "FCS",
  "G50PRO": "PR",
  "G50WEB": "NCC",
  "G51APS": "FCS",
  "G51CSA": "OSA",
  "G51DBS": "SE",
  "G51FSE": "SE",
  "G51FUN": "PR",
  "G51IAI": "AI",
  "G51MCS": "FCS",
  "G51OOP": "PR",
  "G51PRG": "PR",
  "G51REQ": "HCI",
  "G51UST": "OSA",
  "G51WPS": "NCC",
  "G52ADS": "FCS",
  "G52AFP": "PR",
  "G52APR": "PR",
  "G52APT": "AI",
  "G52CCN": "NCC",
  "G52CON": "OSA",
  "G52CPP": "PR",
  "G52GRP": "SE",
  "G52GUI": "HCI",
  "G52HCI": "HCI",
  "G52IFR": "FCS",
  "G52IIP": "AI",
  "G52IMO": "MO",
  "G52MAL": "FCS",
  "G52PAS": "AI",
  "G52PRO": "HCI",
  "G52SEM": "SE",
  "G53AOP": "PR",
  "G53ARS": "AI",
  "G53ASD": "MO",
  "G53BIO": "MO",
  "G53CCT": "HCI",
  "G53CLP": "MO",
  "G53CMP": "PR",
  "G53COM": "FCS",
  "G53CWO": "SE",
  "G53DOC": "PR",
  "G53DSM": "MO",
  "G53DVA": "FCS",
  "G53ELC": "NCC",
  "G53FUZ": "AI",
  "G53GRA": "HCI",
  "G53HCI": "HCI",
  "G53IDA": "PJ",
  "G53IDE": "PJ", 
  "G53IDJ": "PJ",
  "G53IDS": "PJ",
  "G53IDY": "PJ",
  "G53KRR": "AI",
  "G53MLE": "AI",
  "G53NMD": "HCI",
  "G53OPS": "OSA",
  "G53ORO": "MO",
  "G53SEC": "NCC",
  "G53SQM": "SE",
  "G53VAI": "AI",
  "G53VIS": "AI",
  "G54ACC": "NCC",
  "G54ADB": "SE",
  "G54ADM": "OSA",
  "G54ALG": "FCS",
  "G54ARC": "OSA",
  "G54ASB": "MO",
  "G54CCS": "NCC",
  "G54CGA": "HCI",
  "G54CPL": "PR",
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
  "G54MDP": "PR",
  "G54MET": "HCI",
  "G54MGA": "PJ",
  "G54MGP": "PJ",
  "G54MIA": "PJ",
  "G54MIP": "PJ",
  "G54MSP": "AI",
  "G54MXR": "HCI",
  "G54NSC": "MO",
  "G54ORM": "MO",
  "G54OSW": "AI",
  "G54PAL": "FCS",
  "G54PDC": "OSA",
  "G54PRG": "PR",
  "G54PRO": "PJ",
  "G54SAI": "AI",
  "G54SIM": "MO",
  "G54TCN": "NCC",
  "G54UBI": "HCI",
  "G54UIP": "MO",
  "G54VAI": "AI",
  "G54VIS": "AI",
  "G54VSA": "AI",
  "G64ADS": "FCS",
  "G64DBS": "SE",
  "G64FAI": "AI",
  "G64HCI": "PJ",
  "G64ICP": "PR",
  "G64INC": "NCC",
  "G64MIT": "HCI",
  "G64OOS": "SE",
  "G64PIT": "PJ",
  "G64PMI": "PJ",
  "G64PRE": "PJ",
  "G64SPM": "SE",
  "G64SWE": "SE",
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
