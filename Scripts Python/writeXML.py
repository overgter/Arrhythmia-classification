import xml.etree.cElementTree as ET
beatType = "N V N N V"
fp = "371 664 948 1232 1516 1810 2046 2404"
signal = "-0.1450 -0.1450 -0.1450 -0.1450 -0.1450 -0.1450 -0.1450 -0.1450 -0.1200 -0.1350"
root = ET.Element("ecgObject")

ET.SubElement(root, "beatType").text = beatType
ET.SubElement(root, "fp").text = fp
ET.SubElement(root, "signal").text = signal

tree = ET.ElementTree(root)
tree.write("filename.xml")
