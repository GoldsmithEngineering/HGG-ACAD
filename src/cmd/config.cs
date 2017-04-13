///-----------------------------------------------------------------------
/// <copyright file="Config.cs" company="Goldsmith Engineering">
///     (C) Copyright 2017 by Goldsmith Engineering
/// </copyright>
///-----------------------------------------------------------------------
using Autodesk.AutoCAD.Runtime;
using Autodesk.AutoCAD.ApplicationServices;
using Autodesk.AutoCAD.DatabaseServices;
using Autodesk.AutoCAD.EditorInput;
//using Autodesk.AutoCAD.Geometry;
//using System;

// This line is not mandatory, but improves loading performances
[assembly: CommandClass(typeof(HGG_ACAD.Config))]

namespace HGG_ACAD
{
    // This class is instantiated by AutoCAD for each document when
    // a command is called by the user the first time in the context
    // of a given document. In other words, non static data in this class
    // is implicitly per-document!
    /// <summary>
    ///     Series of configuration commands for correct autocad setup.
    /// </summary>
    public class Config
    {
        /// <summary>
        ///     Loads variables and sets values to xml specified.
        /// </summary>
        /// <returns>
        ///     Number of variables set. Null if xml file not found.
        /// </returns>
        // LispFunction is similar to CommandMethod but it creates a lisp 
        // callable function. Many return types are supported not just string
        // or integer.
        [LispFunction("LoadVars", "LoadVars")]
        public int LoadVars(ResultBuffer args) // This method can have any name
        {
            /* PSUDO CODE:
             * open this.xmlconfig
             * if success, than:
             *      iterate through variables
             *      set variable to value
             *      +1  to NumVarsSet
             *      close this.xmlconfig 
             * else:
             *      return nill
             * return NumVarsSet
             */

            return 1;
        }

    }

}
