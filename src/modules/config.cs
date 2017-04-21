///-----------------------------------------------------------------------
/// <copyright file="Config.cs" company="Goldsmith Engineering">
///     (C) Copyright 2017 by Goldsmith Engineering
/// </copyright>
///-----------------------------------------------------------------------
using Autodesk.AutoCAD.Runtime;
using Autodesk.AutoCAD.ApplicationServices;
using Autodesk.AutoCAD.DatabaseServices;
using Autodesk.AutoCAD.EditorInput;
using System.Xml;
using System.Collections.Generic;
//using Autodesk.AutoCAD.Geometry;
//using System;

// This line is not mandatory, but improves loading performances
[assembly: CommandClass(typeof(HGG.AutoCAD.Config))]

namespace HGG.AutoCAD
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
        public System.Collections.Generic.Dictionary<string, string> AutoCADVariables =
            new System.Collections.Generic.Dictionary<string, string>();

        public const string xmlPath = "S://C3DCONFIG//Configurations.xml";
        /// <summary>
        ///     <para><c>LoadVariables</c> is a simple AutoCAD function
        ///     that sets all of the default AutoCAD system variables and prompts
        ///     an error if one or more variables were not set.</para>
        /// </summary>
        /// <returns>
        ///     Number of variables set. Null if xml file not found.
        /// </returns>
        /// <todo>
        ///     <list type="bullet">
        ///         <item>
        ///             <description>S.P.@04-24-16 - Debug in Visual Lisp</description>
        ///         </item>
        ///     </list>
        /// </todo>
        // LispFunction is similar to CommandMethod but it creates a lisp 
        // callable function. Many return types are supported not just string
        // or integer.
        [LispFunction("HGG-Config-LoadXml", "LoadXml")]
        public int LoadXml(XmlDocument xml)
        {
            /* PSUDO CODE:
             * open this.xmlconfig
             * if success, than:
             *      iterate through variables
             *      set variable to value
             *      +1  to NumVarsConfigured
             *      close this.xmlconfig 
             * else:
             *      return nill
             * return NumVarsConfigured
             */
            return 1;
        }

        [LispFunction("HGG-Config-LoadVariables", "LoadVariables")]
        public int LoadVariables() // This method can have any name
        {
            /* PSUDO CODE:
             * iterate through variables
             *   set variable to value
             *   1  to NumVarsSet
             * return NumVarsSet
             */
            return 1;
        }
    }
}