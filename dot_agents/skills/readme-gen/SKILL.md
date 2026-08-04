---
name: readme-gen
description: Generates project READMEs with two variants: a generic open-source template and a specialized 42 School project template. Use when the user asks to generate, update, or create a README file.
---

# README Generator Skill

## Overview
This skill generates structured, professional `README.md` files. It supports two distinct variants based on the user's project context. Before generating, determine which variant applies (by looking for 42 specific files like `subject.txt` or asking the user) and apply the correct template.

## Workflow
1. **Analyze:** Check the project files (e.g., `package.json`, `subject.txt`, source code) to extract project details (name, tech stack, descriptions).
2. **Determine Variant:** Decide whether to use the "Generic" or "42 School" variant.
3. **Draft:** Construct the README content strictly following the matching template below.
4. **Write:** Write the finalized markdown to the root `README.md`.

---

## Variant A: Generic Project Template
Use this for standard open-source projects, generic applications, and libraries.

1. **Title and Badges**: `# <Project Name>`. Include relevant standard badges (e.g., Build status, NPM Version, License).
2. **Overview**: A concise description of what the project does, the problem it solves, and why it exists.
3. **Features**: A bulleted list of the application's core features.
4. **Prerequisites**: Minimum versions of tools or dependencies required (e.g., Node.js >= 18, Docker).
5. **Installation**: Step-by-step commands to clone and build/install the project.
6. **Usage**: Code examples or CLI commands demonstrating how to run or use the application.
7. **Architecture / Tech Stack**: (Optional) Brief description of the technologies used.
8. **Contributing**: Simple guidelines on how to submit PRs or issues.
9. **License**: Standard license statement (e.g., MIT, GPL).

---

## Variant B: 42 School Project Template
Use this exclusively for 42 School projects (e.g., Tokenizer, Web3, Core curriculum).

1. **Title and Badges**
   - Title: `# <Project Name> (42 <Track Name, e.g. Web3>)`
   - Badges (use shields.io): `![42 School](https://img.shields.io/badge/School%20project-000000?style=for-the-badge&logo=42&logoColor=white)`, plus any tech stack badges (e.g., Web3, C, C++).
   - Blockquote summary: `> 42 School project: [Brief description]`
2. **Overview**
   - Describe the project and its requirements.
   - Mention where the subject PDF/text is located.
   - List the deliverables (e.g., code, deployment, documentation).
3. **Tech Stack**
   - Markdown table with Component and Technology (e.g., Language, Libraries, Target environment).
4. **Structure**
   - A tree-like code block showing the directory layout with brief explanations.
5. **Requirements**
   - e.g., Norminette compliance, specific compilers, EVM wallet, etc.
6. **Getting Started**
   - Step-by-step numbered list to compile (e.g., `make`), run, or deploy.
7. **Documentation**
   - Links to any inner markdown docs.
8. **Deployed Contracts / Live Demo**
   - (For Web3/Web projects) Network name, Contract Addresses, and Explorer links (use `TBD` if not deployed).
9. **License**
   - Exactly: `This project is part of the 42 School curriculum.`