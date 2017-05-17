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

        public string xmlPath = "S://C3DCONFIG//Configurations.xml";
        private XmlDocument xml = new XmlDocument();
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
        public int LoadXML(XmlDocument xml)
        {
            XmlNodeList xmlVariables = xml.SelectNodes("Configuration/Variable");
            foreach (XmlNode node in xmlVariables)
            {
                this.AutoCADVariables.Add(node.Attributes["name"].Value,
                    node["Value"].InnerText);
            }
            return AutoCADVariables.Count;
        }

        public void SetVariables() // This method can have any name
        {
            foreach (KeyValuePair<string, string> variable in this.AutoCADVariables)
            {
                try
                {
                    Application.SetSystemVariable(variable.Key, int.Parse(variable.Key));
                }
                catch (System.FormatException e)
                {
                    Application.SetSystemVariable(variable.Key, variable.Value);
                }
            }
        }

        [LispFunction("LoadVariables", "HGG:Config:LoadVariables")]
        public void LoadVariables()
        {
            this.xml.Load(this.xmlPath);
            if (this.LoadXML(this.xml) >= 0)
            {
                this.SetVariables();
            }

            // Write to console: "Variables loaded."
        }
}
}