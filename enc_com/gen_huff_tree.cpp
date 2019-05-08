/**
* Generates the huffman tree based on the probability of a each character
* Assumes probabilities are stored in a file huffman.txt
**/

#include <stdio.h>
#include <iostream>
#include <vector>

using namespace std; 

typedef struct Nodeptr
{
	char letter;
	float prob; //probability of occurence
	struct node *left, *right;
} Node;

void csci212sort(vector<Node> leafs)
{
	float temp;
	char c;
	for (int i = 0; i < leafs.size() - 1; i++)
	{
		for (int j = i + 1; j < leaf.size(); j++)
		{
			if (leafs[i].prob > leafs[j].prob)
			{
				temp = leafs[i].prob;
				c = leafs[i].letter;
				leafs[i].prob = leafs[j].prob;
				leafs[i].letter = leafs[j].letter;
				leafs[j].prob = temp;
				leafs[j].letter = c;
			}
		}
	}
}
	
int main()
{
	vector<Node> leafs;
	node *root;
	FILE *fp;
	float prob[29];
	char letter[29];
	float tot_prob=0;
	vector<Node> templist, temp2;
	int j = 2;
	Node *temp;

	fp = fopen("huffman.txt", "r");

	for (int i = 0; i < 29; i++)				//load each prob and letter into node structs
	{
		fscanf(fp, "%c %f", &letter[i], &prob[i]);
		Node temp;
		temp.letter = letter[i];
		temp.prob = prob[i];
		temp.left = NULL;
		temp.right = NULL;
		leafs.push_back(temp);
	}
	fclose(fp);
	templist = leafs;
	while (tot_prob <= 1)
	{
		temp = (Node*)malloc(sizeof(Node));
		tot_prob = templist[0].data + templist[0].data + templist[1].data;
		temp->data = tot_prob;
		temp->letter = '$'
		temp->left=&templist[0];
		temp->right = &templist[1];
		temp2 = templist;
		templist.clear();
		templist.push_back(*temp);
		if (j==2)
		{
			for (int i = j; i < temp2.size(); i++)
			{
				templist.push_back(leafs[i]); //push leafs into temp2
			}
		} //if
		else
		{
			for (int i = 2; i < temp2.size(); i++)
			{
				templist.push_back(temp2[i]); //push rest into temp2
			}
		} //else
		csci212sort(templist);					//nodes sorted from lowest to highest probability
		j++;
	} //while
	return temp;
}
	
