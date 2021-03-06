(* ::Package:: *)

(************************************************************************)
(* This file was generated automatically by the Mathematica front end.  *)
(* It contains Initialization cells from a Notebook file, which         *)
(* typically will have the same name as this file except ending in      *)
(* ".nb" instead of ".m".                                               *)
(*                                                                      *)
(* This file is intended to be loaded into the Mathematica kernel using *)
(* the package loading commands Get or Needs.  Doing so is equivalent   *)
(* to using the Evaluate Initialization Cells menu command in the front *)
(* end.                                                                 *)
(*                                                                      *)
(* DO NOT EDIT THIS FILE.  This entire file is regenerated              *)
(* automatically each time the parent Notebook file is saved in the     *)
(* Mathematica front end.  Any changes you make to this file will be    *)
(* overwritten.                                                         *)
(************************************************************************)



xAct`DivFree`$xTensorVersionExpected={"1.0.5",{2013,1,27}};
xAct`DivFree`$Version={"0.1.0",{2013,08,29}}


(* DivFree: Make tensors divergence free at definition time *)

(* Copyright (C) 2013 Leo C. Stein *)

(* This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License,or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 59 Temple Place-Suite 330, Boston, MA 02111-1307, USA. 
*)


(* :Title: DivFree *)

(* :Author: Leo C. Stein *)

(* :Summary: Make tensors divergence free at definition time. *)

(* :Brief Discussion: DivFree is a package to demonstrate using xTension. It adds an option, DivFree, to DefTensor to declare a tensor divergence-free at the time of definition. *)
  
(* :Context: xAct`DivFree` *)

(* :Package Version: 0.1.0 *)

(* :Copyright: Leo C. Stein (2013) *)

(* :History: TODO *)

(* :Keywords: TODO *)

(* :Source: DivFree.nb *)

(* :Warning: TODO *)

(* :Mathematica Version: 8.0 and later *)

(* :Limitations: *)
	
(* :Acknowledgements: *)


If[Unevaluated[xAct`xCore`Private`$LastPackage]===xAct`xCore`Private`$LastPackage,xAct`xCore`Private`$LastPackage="xAct`DivFree`"];


BeginPackage["xAct`DivFree`",{"xAct`xTensor`","xAct`xPerm`","xAct`xCore`"}]


If[Not@OrderedQ@Map[Last,{$xTensorVersionExpected,xAct`xTensor`$Version}],Throw@Message[General::versions,"xTensor",xAct`xTensor`$Version,$xTensorVersionExpected]]


Print[xAct`xCore`Private`bars]
Print["Package xAct`DivFree`  version ",$Version[[1]],", ",$Version[[2]]];
Print["Copyright (C) 2013, Leo C. Stein, under the General Public License."];


Off[General::shdw]
xAct`xForm`Disclaimer[]:=Print["These are points 11 and 12 of the General Public License:\n\nBECAUSE THE PROGRAM IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES PROVIDE THE PROGRAM `AS IS\.b4 WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION.\n\nIN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR REDISTRIBUTE THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES."]
On[General::shdw]


If[xAct`xCore`Private`$LastPackage==="xAct`DivFree`",
Unset[xAct`xCore`Private`$LastPackage];
Print[xAct`xCore`Private`bars];
Print["These packages come with ABSOLUTELY NO WARRANTY; for details type Disclaimer[]. This is free software, and you are welcome to redistribute it under certain conditions. See the General Public License for details."];
Print[xAct`xCore`Private`bars]]


DivFree::usage="DivFree is an option for DefTensor to declare a tensor divergence free. Use DivFree->{covd[-a],...} to declare that the tensor is divergence free on index +a with respect to the covariant derivative covd.";


Begin["`Private`"]


(****************************** 2. Main code for DivFree *****************************)


If[FreeQ[First/@Options[DefTensor],DivFree],
Unprotect[DefTensor];
Options[DefTensor]=Append[Options[DefTensor],DivFree->{}];
Protect[DefTensor];];


DefTensor::BadDivFreeIndices="Indices supplied to DivFree (`1`) do not all appear with opposite character in indices of tensor (`2`).";


CheckDivFree[tensor_[inds___],df:{_?CovDQ[_]...}]:=Module[{dfinds=Union[First/@df]},
With[{changedfinds=ChangeIndex/@dfinds},
(* Every index in changedfinds must be in inds *)
If[Intersection[{inds},changedfinds]=!=changedfinds,
Throw@Message[DefTensor::BadDivFreeIndices,dfinds,{inds}];
];
];
];
CheckDivFree[_,df_]:=Throw@Message[DefTensor::invalid,df,"format for DivFree"];


(* Check the input *)
DefTensorBeginning[head_[indices___],dependencies_,sym_,options___]:=Module[{df=OptionValue[DefTensor,{options},DivFree]},
CheckDivFree[head[indices],df];
];
(* Here we do the actual work *)
DefTensorEnd[head_[indices___],dependencies_,sym_,options___]:=Module[{df=OptionValue[DefTensor,{options},DivFree]},
With[{rules=Flatten[MakeRule[{Evaluate[#[head[indices]]],0}]&/@df]},
If[$DefInfoQ&&Length[rules]>0,
Print["Generated rules:"];
Print[rules];
];
AutomaticRules[head,rules];
];
];


xTension["DivFree`",DefTensor,"Beginning"]=DefTensorBeginning;
xTension["DivFree`",DefTensor,"End"]=DefTensorEnd;


Protect[DivFree];


End[];
EndPackage[];



