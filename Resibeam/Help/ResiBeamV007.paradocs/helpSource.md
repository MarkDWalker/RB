Resi-Beam Interface Overview
@ref:@home
@contents: no

Resi-Beam is an application designed to simplify the beam design process for beam scenarios typcially found in residential and light commercial applications, more specifically:

a. analysis of simple beams, or beams with overhangs at one (1) or both ends, in order to obtain beam forces including shear, moment and deflection.
b. provide graphical representation of forces throughout the length of the beam.
c. calculation of stresses within beam section for wood lumber, LVL and steel W sections.
d. provide stresses throughout the beam, and provide calculations for the chosen section using the largest forces in the beam.

@ref:InterfaceOverview
@title:Resi-Beam Interface Overview
@contents: yes




![AppOverviewReduced](AppOverviewReduced s750x472)




GENERAL:

Generally the flow of the program runs from left to right. 

- The left most column is used to add beams and beam geometry, and to add, edit and delete loads.

- The middle column shows the results of the loads applied to the specified beam. The analysis results will be shown for beam selected in the beam list in the first column.

- The right most column uses the forces shown in the analysis for a selected beam and calculates the adequacy of the chosen section, based upon the specified design conditions. The design results can be seen in the stress results section of this panel and also in the status bar at the top, which also shows some selected design information for additionl verification.


![image_0016](image_0016 s365x163)


BEAM LIST: 
@seealso:BeamEditor

The BEAM LIST is the left most column of the application and provides the opportunity create one (1) or more beams, to set the span (length) of the beams and also several other geometric properties that are used for the calculation of deflection and in the presentation of the deflection graph.


![image_0017](image_0017 s352x513)

BEAM INSPECTOR:
The Beam Inspector allows for editing of the selected beam as well as adding, editing and deleting loads. It contains the following:

-Beam Editor
-Load List
-Load Properties


LOAD LIST:
This panel provides the a listing of all of loads that have been applied to the beam. The loads can be reordered, which will affect their display location in the load diagram pane.

![image_0002](image_0002 s389x734)

LOAD DIAGRAM VIEW:
This view shows a graphical representation of all of the loads that have been added to the beam. The beam currently selected in the load list will be blue, while the remainder of the loads will be brown.


SHEAR, MOMENT & DEFLECTION GRAPHS:
These views show graphs of the respective items for the length of the beam. The green horizontal line represents the beam. The red line graph respresents the summation of all of the respective forces for all of the loads. The blue graph line represents the graph for the single load currently selected in the load list panel. Any grey line graphs are graphs of individual loads.

Values that result from either an induvidual load or values that result from the summation of all of loads may be shown on the graphs, based upon the radio selection at the top of the middle pane.

![image_0018](image_0018 s442x700)


CURRENT MATERIAL SELECTION:
The user can select Wood Lumber, LVL, or Steel W (W section), in order to get the resultant stresses in the loaded member.



![image_0019](image_0019 s441x177)
![image_0020](image_0020 s493x212)
![image_0021](image_0021 s497x253)


SECTION GEOMETRY PANEL:
Based upon the selection in the Current Material Selection tab, different options will be available in the geometry panel. For wood standard lumber sections can be selected. For steel standard steel sections can be selected.


![image_0024](image_0024 s473x138)
![image_0023](image_0023 s468x117)
![image_0022](image_0022 s471x141)


GRADE PANEL:
Again different options will be available for selection based upon the material selected. The grade of material will be the basis for the allowable stresses for the beam.


![image_0025](image_0025 s475x203)
![image_0026](image_0026 s474x195)
![image_0027](image_0027 s472x104)

ADJUSTMENT FACTORS:
This pane allows further adjustments to the allowable stresses.

![image_0028](image_0028 s421x196)


STRESS RESULTS:
This table shows the allowable bending stresses (Fb), adjusted allowable bending stresses (FbA), and the acutal bending stresses (fb) in psi, the allowable shear stresses (Fv), the adjusted allowable shear stress (FvA), and actual shear stress (fv) in psi, and also the allowable deflection alongside the actual deflections.

Any bending stress, shear stress or deflection in the member that exceeds the design limits will be shown in red. Currently the delfection limit is set at L/240 for the beam deflection with all of the loads applied.



@ref:BeamEditor
@title:Beam Editor
@contents: yes


![image_0029](image_0029 s386x217)

The beam editor displays the data related to the beam geometry and is to be modified to by the user to fit the desired conditions.


DESCRIPTION: 
A short string identifier for the beam.

BEAM LENGTH: 
The length of the beam and beam span in feet. Must be a positve number.

SUPPORT LOCATION 1:
The Location of the first support in feet.

SUPPORT LOCATION 2:
The location of the second support in feet.

M OF INT (I):
User input value for the moment of inertia of the beam in inches^4. This value is used for the calculation of the deflection graph.

MOD OF EL (E): 
User input value for the modulus of elasticity of the beam. This value is used for the calculation of the deflection graph. The input value must be in kips per square inch.


NO. OF DATA PTS.: 
This must be a positive whole number. This represents the number of data points that are calculated for the graph. The minimum number is 3, as at least a point at the beginning of the beam, the middle of the beam and the end of the beam is required. 

Ideally, an odd number of data points should be used, as this will give a data point at the midpoint of the beam. Also, the larger the value for this field, the more accurate the graph will be, however, a larger value can affect performance.



To edit the values, on the value of interest in the table and press enter.


@ref:LoadList
@title:Load List and Load Properties
@keywords: second, page, interesting
@contents: yes



The load list contains the list of loads currently applied to the beam selected in the Beam List. The loads can be added, deleted and reordered. The load type can also be changed by clicking on the icon in the 'Type' field.


![image_0030](image_0030 s340x169)

The Load Properties displays the data for the currently selected load, from the load list.


LOAD DESCRIPTION:
A string to describe the load.

LOAD VALUE:
The value of the load to be applied in kips.
For concentrated load, this is the value in kips.
For Uniform loads, this is the value in kips per foot.
For linear loads, this is the value in kips of the largest value of the load.

LOAD TYPE:
The user should select one of the options, concentrated, uniform, or linear.

For single concentrated loads, calculations are done based upon the standard beam equations at each data point along the beam, as specified in the NO OF DATA PTS. field of the beam geometry.

For linear and uniform loads, an iterative approach is used, with the appropriate load applied at each prescribed point along the beam and the results summed up to arrive at a total result for each load.

START LOCATION:
This field is used for all load types. For concentrated loads, this is the location of the applied load. For uniform and linear load types, this field is the start location of the respective load.

END LOCATION:
This field is used for uniform and linear load, and is inactive for concentrated loads. For both uniform and linear, this is the location of the end of the load, and must be greater than the START LOCATION value.


To edit the values for a particular load, first select the desired value in the load list and then press enter.


A load can be added to the load list press the add button, represented by a "+" to quickly add a 1 kip concentrated load at the midpoint of the beam. This load can be modified once applied.

to delete a load, first select a load in the load list, and then click the delete button, represented by "-" image. Note that at least one (1) load must be present.




@ref:GraphsPanel
@title:Beam Graphs Panel
@contents: yes

![image_0002](image_0002 s389x734)
The graphs panels (listed from top to bottom) show the following information:


LOAD DIAGRAM:
Load diagram shows the beam and a representation of the applied loads.

SHEAR DIAGRAM: 
Shear diagram showS a shear graph for all of the individual loads applied as well as a combination of all of the loads applied.

MOMENT DIAGRAM: 
Moment diagram showS a moment graph for all of the individual loads applied as well as a combination of all of the loads applied.

DEFLECTION DIAGRAM: 
Deflection diagram showing a deflection graph for all of the individual loads applied as well as a combination of all of the loads applied. Note that the deflection diagram values are based upon the moment of inertia and modulus of elasticity values entered in the Beam Geometry Panel.

VALUE LABELS:
The program is able to label the values of the shear, moment, and deflection diagrams along the beam. By default, the graph showing the total of all the loads combined is shown. To view the labels for an individual load, select a load in the load list panel, and select the appropriate radio button at the top of the graphs panel.

Additionaly the results for shear, moment and deflection can be viewed in tabular format by selecting the appropriate button at the top of the graphs panel. v will show the shear, m will show the moment, and d will show the deflection. These tabular results can show either the total results of all the loads (default) or the values for each individual loads. To view the individual loads, select the load in the load list panel and select the appropriate radio button at the top of the graphs panel.


@ref:BeamAnalysisIntroduction
@title:Beam Analysis Introduction
@contents: yes


![image_0018](image_0018 s442x700)

The Resi-Beam analysis functionality allows for the calculation of the bending stress, shear stress and deflection of a simply supported beam (with the option of overhangs on one or both ends) and allows for the comparison of the stresses generated to the allowable stresses. In general the workflow is as follows:

1.) The user selects the type of beam, either lumber, LVL, or a steel w section.

2.) The user enters the geometry of the beam to be analyzed.

3.) Based upon the type of beam selected, the user can select the desired grade of material. In the case of wood, if a dimensional lumber section is chosen, southern pine grades are available. In the case that an LVL section is chosen, several different products are available. Steel section are available in either 36 ksi or 50 ksi variants.

4.) In order to obtain the allowable design stresses, applicable factors need to be applied to the ultimate yield stresses. Different options are available for lumber, LVL, and steel. 



@ref:MaterialSelectionPanel
@title:Material & Geometry Selection Panels
@contents: yes

![image_0021](image_0021 s497x253)
![image_0020](image_0020 s493x212)
![image_0019](image_0019 s441x177)


A beam can be analyzed based upon the forces obtained in the Graphs Panel (center panel). In order to complete the analysis one of three beam types must be chosen.


-Lumber, allows for a section selection of a typical lumber size

-LVL, allow for the section selection of a typical LVL section. 

-Steel W allows for the selection of a typical W section.




@ref:GradePanel
@title:Grade Panel
@contents: yes


![image_0024](image_0024 s473x138)
![image_0023](image_0023 s468x117)
![image_0022](image_0022 s471x141)

Once the material and section geometry are selected, a grade of material can be selected. The grade directly determines the base values for the allowable stresses of the beam.

For a material selection of wood, depending on the section selection, the user will have different options. If a dimensional lumber section has been selected in the Geometry Selection Panel, then the choices are available for Southern Yellow Pine lumber grades. If an LVL size has been selected in the Geometry Panel then either grades for Georgia Pacific or Wyerhaeuser are available.




Should a steel material be selected then, the user has a choice of either 50 ksi , or 36 ksi steel (Fy, yield strength).

If is important to note that the base allowable stress values must be adjusted for design purposes, and are typically reduced. This is accomplished through the adjustments panel.

@seealso:AdjustmentsPanel


@ref:AdjustmentsPanel
@title:Adjustments Panel
@contents: yes

![image_0004](image_0004 s469x235)

The adjustment panel allows for the adjustment of the allowable bending stress and the allowable shear stress.  Depending on the type of material selected, different values will appear. 

@seealso:WoodAdjustmentFactors, SteelAdjustmentFactors


@ref:WoodAdjustmentFactors
@title:Wood Adjustment Factors
@contents: yes

![image_0025](image_0025 s475x203)

Wood adjustment factors are necessary to adjust the base or tabulated allowable stresses due to physical and geometric properties of your particular application. Below is a brief description of each factor:



Load Duraction Factor (Cd)- length of time a load is applied

Wet Service Factor (Cm) - wet/dry conditions of the wood

Temperature Factor (Ct) - expected ambient air temperatures 

Beam Stablity Factor (Cl) - top chord bracing

Size Factor (Cf) - depth of the member

Flat Use Factor (Cfu) - applied to a member turned flat

Repetitive Member Factor (Cr) - redundancy of the member


For additional help on wood adjustment factors, refer to NDS specifications.


@ref:SteelAdjustmentFactors
@title:Steel Adjustment Factors
@contents: yes

![image_0027](image_0027 s472x104)

Steel adjustment factors are prescribed factors of safety to ensure the steel has adequate capactiy to handle the design loads and forces. Both the allowable bending stress and the allowable shear stress require adjustment factors.

@seealso: SteelBendingAdjustment, SteelShearAdjustment


@ref:SteelBendingAdjustment
@title:Steel Allowable Bending Stress Adjustment
@contents: yes



![image_0031](image_0031 s499x393)


A typical value for the allowable bending stress adjustment is 0.66, which reduces the the allowable stress by roughly 2/3. This factor is based upon several different criteria, including whether the selected section is compact or non-compact and the spacing of the lateral bracing of the compression flange. 

This factor is beyond the scope of this help section, however the most simplistic condition is a compact section with a fully braced compression flange, which results in a value of 0.66.

For complex situations, the user can enter a custom value.


@ref:SteelShearAdjustment
@title:Steel Allowable Shear Stress Adjustment
@contents: yes


![image_0032](image_0032 s368x225)


A typical value for the allowable shear stress adjustment is 0.40. This factor is based upon the stiffness of the web, so the thinner and taller the web, smaller the factor.

This factor is beyond the scope of this help section, however the most simplistic condition for a rolled steel section is:

beam depth (h) / web thickness (tw) <= 380/sqrt(Fy) which results in an adjustment factor of 0.40

Where Fy is the yield strength of the steel, or typically 36 ksi or 50 ksi.







