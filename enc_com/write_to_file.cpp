void write_to_file(Node root, FILE *fp)
{
	if (root.letter != '$')
	{
		fprintf(fp, "%d", 0);
		write_to_file(root-left,fp);
		fprintf(fp, "%d", 1);
		write_to_file(root->right, fp);
	} //if
	else
	{
		fprintf(fp, "%c\n", root.letter);
	}
}
